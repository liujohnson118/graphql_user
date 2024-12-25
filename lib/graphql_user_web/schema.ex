defmodule GraphqlUserWeb.Schema do
  alias Absinthe.Phase.Document.Arguments.Data
  use Absinthe.Schema

  import_types GraphqlUserWeb.Types.User
  import_types GraphqlUserWeb.Schema.Queries.User
  import_types GraphqlUserWeb.Schema.Mutations.User
  import_types GraphqlUserWeb.Schema.Mutations.Preference
  import_types GraphqlUserWeb.Schema.Subscriptions.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :preference_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlUser.Repo)
    dataloader = Dataloader.add_source(Dataloader.new, GraphqlUser.Accounts, source)
    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end
end
