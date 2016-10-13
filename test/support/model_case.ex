defmodule Gateway.API.ModelCase do
  @moduledoc """
  This module defines the test case to be used by
  model tests.
  You may define functions here to be used as helpers in
  your model tests. See `errors_on/2`'s definition as reference.
  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias Gateway.DB.Models.Plugin

  using do
    quote do
      alias Gateway.DB.Repo
      alias Gateway.DB.Models.Plugin

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Gateway.API.ModelCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Gateway.DB.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Gateway.DB.Repo, {:shared, self()})
    end

    :ok
  end

  def get_plugin_fixture do
    Plugin
    |> EctoFixtures.ecto_fixtures
  end

  @doc """
  Helper for returning list of errors in a struct when given certain data.
  ## Examples
  Given a User schema that lists `:name` as a required field and validates
  `:password` to be safe, it would return:
      iex> errors_on(%User{}, %{password: "password"})
      [password: "is unsafe", name: "is blank"]
  You could then write your assertion like:
      assert {:password, "is unsafe"} in errors_on(%User{}, %{password: "password"})
  """
  def errors_on(struct, data) do
    data
    |> (&struct.__struct__.changeset(struct, &1)).()
    |> Enum.flat_map(fn {key, errors} -> for msg <- errors, do: {key, msg} end)
  end
end