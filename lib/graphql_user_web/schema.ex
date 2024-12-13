defmodule GraphqlUserWeb.Schema do
  use Absinthe.Schema

  import_types GraphqlUserWeb.Types.User
  import_types GraphqlUserWeb.Schema.Queries.User
  import_types GraphqlUserWeb.Schema.Mutations.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end
end
