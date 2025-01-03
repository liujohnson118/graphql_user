defmodule GraphqlUser.Accounts do
  alias GraphqlUser.Accounts.{User, Preference}
  alias GraphqlUser.Repo
  alias EctoShorts.Actions

  def create_user(attrs) do
    Actions.create(User, attrs)
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
    filter = params
      |> pagination_filter()
      |> Map.put(:preference, preferences_filter(params))
    Actions.all(User, filter)
  end

  defp preferences_filter(params) do
    preference_keys = [:likes_emails, :likes_phone_calls, :likes_faxes]
    Map.take(params, preference_keys)
  end

  defp pagination_filter(params) do
    pagination_keys = [:before, :after, :first]
    Map.take(params, pagination_keys)
  end
end
