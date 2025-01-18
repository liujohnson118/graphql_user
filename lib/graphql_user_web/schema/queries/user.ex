defmodule GraphqlUserWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation

  alias GraphqlUserWeb.Resolver

  object :user_queries do
    field :user, :user do
      arg :id, non_null(:id)

      resolve fn %{id: id}, _ ->
        Resolver.User.find(%{id: id})
      end
    end

    field :users, list_of(:user) do
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean
      arg :before, :integer
      arg :after, :integer
      arg :first, :integer

      resolve fn params, _ ->
        Resolver.User.all(params)
      end
    end
  end
end
