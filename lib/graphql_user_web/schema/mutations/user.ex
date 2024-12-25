defmodule GraphqlUserWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation

  object :user_mutations do
    field :create_user, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :preference, non_null(:preference_input)

      resolve &GraphqlUserWeb.Resolver.User.create/2
    end

    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string

      resolve &GraphqlUserWeb.Resolver.User.update/2
    end
  end
end
