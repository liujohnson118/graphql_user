defmodule GraphqlUserWeb.Types.User do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "User subscription preference settings"
  object :preference do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
    field :user_id, :id
    field :id, :id
  end

  @desc "Input for user subscription preference"
  input_object :preference_input do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :preference, :preference, resolve: dataloader(GraphqlUser.Accounts, :preference)
  end
end
