defmodule GraphqlUserWeb.Schema.Queries.User do
  import Ecto.Query

  use Absinthe.Schema.Notation

  alias GraphqlUserWeb.Resolver
  alias GraphqlUser.Accounts.User
  alias EctoShorts.Actions

  object :user_queries do
    field :user, :user do
      arg :id, non_null(:id)

      resolve fn %{id: id}, _ ->
        Resolver.User.find(%{id: id})
      end
    end

    field :users, list_of(:user) do
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean
      arg :before, :integer
      arg :after, :integer
      arg :first, :integer

      resolve fn params, _ ->
        Resolver.User.all(params)
      end
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
