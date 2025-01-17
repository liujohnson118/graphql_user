defmodule GraphqlUser.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias GraphqlUserWeb.Schema.Queries.User

  schema "users" do
    field :name, :string
    field :email, :string
    has_one :preference, GraphqlUser.Accounts.Preference

    timestamps(type: :utc_datetime)
  end

  @doc false
  @available_fields [:name, :email]
  def changeset(user, attrs) do
    user
      |> cast(attrs, @available_fields)
      |> validate_required(@available_fields)
      |> cast_assoc(:preference)
  end

  def filter_users_by_preferences(params) do
    User.filter_users_by_preferences(params)
  end
end
