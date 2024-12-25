defmodule GraphqlUserWeb.Schema.Mutations.Preference do
  use Absinthe.Schema.Notation

  object :preference_mutations do
    field :update_preference, :preference do
      arg :id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean

      resolve &GraphqlUserWeb.Resolver.Preference.update/2
    end
  end
end