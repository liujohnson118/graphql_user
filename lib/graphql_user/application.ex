defmodule GraphqlUser.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GraphqlUser.Repo,
      GraphqlUserWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:graphql_user, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GraphqlUser.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GraphqlUser.Finch},
      # Start a worker by calling: GraphqlUser.Worker.start_link(arg)
      # {GraphqlUser.Worker, arg},
      # Start to serve requests, typically the last entry
      GraphqlUserWeb.Endpoint,
      {Absinthe.Subscription, GraphqlUserWeb.Endpoint}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlUser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlUserWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
