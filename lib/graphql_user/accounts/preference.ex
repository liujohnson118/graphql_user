defmodule GraphqlUser.Accounts.Preference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    field :likes_faxes, :boolean, default: false
    belongs_to :user, GraphqlUser.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  @available_fields [:likes_emails, :likes_phone_calls, :likes_faxes]
  def changeset(preference, attrs) do
    preference
      |> cast(attrs, @available_fields)
      |> validate_required(@available_fields)
  end
end
