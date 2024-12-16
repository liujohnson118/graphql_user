defmodule GraphqlUserWeb.Types.User do
  use Absinthe.Schema.Notation

  @desc "User subscription preference settings"
  object :preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
    field :user_id, :id
  end

  @desc "Input for user subscription preferences"
  input_object :preferences_input do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :preferences, :preferences
  end
end
