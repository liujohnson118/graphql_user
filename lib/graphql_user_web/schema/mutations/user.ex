defmodule GraphqlUserWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation

  object :user_mutations do
    field :create_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      arg :preferences, :preferences_input

      resolve &GraphqlUserWeb.Resolver.User.create/2
    end

    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string

      resolve &GraphqlUserWeb.Resolver.User.update/2
    end

    field :update_user_preferences, :preferences do
      arg :user_id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean

      resolve &GraphqlUserWeb.Resolver.User.update_user_preferences/2
    end
  end
end
