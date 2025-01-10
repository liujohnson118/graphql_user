defmodule GraphqlUser.ResolverHitsAgent do
  use Agent

  def start_link(initial_value) do
    initial_state = %{create_user: initial_value}
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def get(key) do
    key = String.to_atom(key)
    Agent.get(__MODULE__, & &1[key])
  end

  def add_user do
    Agent.update(__MODULE__, fn state -> Map.update!(state, :create_user, &(&1 + 1)) end)
  end
end
