defmodule GraphqlUserWeb.Schema do
  use Absinthe.Schema

  import_types GraphqlUserWeb.Types.User
  import_types GraphqlUserWeb.Schema.Queries.User
  import_types GraphqlUserWeb.Schema.Mutations.User
  import_types GraphqlUserWeb.Schema.Subscriptions.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end
end
