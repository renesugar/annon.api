defmodule :os_gateway_tasks do
  @moduledoc """
  Nice way to apply migrations inside a released application.
  Example:
      ./bin/$APP_NAME command "tr_db_tasks" migrate!
  """

  def migrate! do
    migrations_dir = Path.join(["priv", "repos", "migrations"])

    load_app()

    Gateway.DB.Repo
    |> start_repo

    Gateway.DB.Logger.Repo
    |> start_repo
    |> Ecto.Migrator.run(migrations_dir, :up, all: true)

    System.halt(0)
    :init.stop()
  end

  defp start_repo(repo) do
    repo.start_link()
    repo
  end

  defp load_app do
    start_applications([:logger, :postgrex, :ecto])
    :ok = Application.load(:gateway)
  end

  defp start_applications(apps) do
    Enum.each(apps, fn app ->
      {_ , _message} = Application.ensure_all_started(app)
    end)
  end
end