defmodule GraphqlUserWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.ChannelTest
      import Absinthe.Phoenix.SubscriptionTest

      @endpoint GraphqlUserWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlUser.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(GraphqlUser.Repo, {:shared, self()})
    end

    {:ok, socket} = Phoenix.ChannelTest.connect(GraphqlUserWeb.UserSocket, %{})
    {:ok, socket: Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)}
  end
end
