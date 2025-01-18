defmodule GraphqlUserWeb.Schema.Mutations.Preference do
  use Absinthe.Schema.Notation

  object :preference_mutations do
    field :update_user_preference, :preference do
      arg :user_id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean

      resolve &GraphqlUserWeb.Resolver.Preference.update_user_preference/2
    end
  end
end
