defmodule GraphqlUser.Accounts.User do
  import Ecto.Query
  import Ecto.Changeset

  use Ecto.Schema

  alias GraphqlUser.Accounts.User
  alias EctoShorts.Actions

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
    preferences_filter = params |> preferences_filter()
    query =
      from u in User,
        join: p in assoc(u, :preference),
        where: ^build_preferences_conditions(preferences_filter),
        select: u
    pagination_filter = params |> pagination_filter()

    Actions.all(query, pagination_filter)
  end

  defp preferences_filter(params) do
    filter_keys = [:likes_emails, :likes_phone_calls, :likes_faxes]
    Map.take(params, filter_keys)
  end

  defp pagination_filter(params) do
    filter_keys = [:before, :after, :first]
    Map.take(params, filter_keys)
  end

  defp build_preferences_conditions(preference_params) do
    Enum.reduce(preference_params, true, fn {key, value}, acc ->
      dynamic([_, p], field(p, ^key) == ^value and ^acc)
    end)
  end
end
