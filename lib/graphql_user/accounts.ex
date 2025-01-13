defmodule GraphqlUser.Accounts do
  import Ecto.Query

  alias EctoShorts.Actions
  alias GraphqlUser.Accounts.{User, Preference}
  alias GraphqlUser.Repo
  alias GraphqlUser.ResolverHitsAgent

  def create_user(attrs) do
    case Actions.create(User, attrs) do
      {:ok, user} ->
        ResolverHitsAgent.add_user
        {:ok, user}
      {:error, changeset} -> {:error, "User not created. Changeset: #{changeset.errors}"}
    end
  end

  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, "User with #{id} not found"}
      user -> {:ok, user}
    end
  end

  def update_user(id, attrs) do
    with {:ok, user} <- get_user(id) do
      user
        |> User.changeset(attrs)
        |> Repo.update()
    end
  end

  def get_users(params) do
    {:ok, filter_users_by_preferences(params)}
  end

  def update_preference(id, attrs) do
    with {:ok, _preference} <- get_preference(id) do
      Actions.update(Preference, id, attrs)
    end
  end

  defp get_preference(id) do
    case Repo.get(Preference, id) do
      nil -> {:error, "Preference with #{id} not found"}
      preference -> {:ok, preference}
    end
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
