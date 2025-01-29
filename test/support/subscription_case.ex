defmodule GraphqlUserWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.ChannelTest
      use GraphqlUserWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest,
       schema: GraphqlUserWeb.Schema
      setup tags do
        {:ok, socket} = Phoenix.ChannelTest.connect(GraphqlUserWeb.Sockets.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)
        {:ok, %{socket: socket}}
      end
    end
  end
end
