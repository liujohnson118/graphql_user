defmodule GraphqlUserWeb.Resolver.User do
  def all(params) do
    GraphqlUserWeb.User.all(params)
  end

  def find(%{id: id}) do
    GraphqlUserWeb.User.find(%{id: id})
  end

  def create(params, _) do
    GraphqlUserWeb.User.create(params)
  end

  def update(%{id: id} = params, _) do
    GraphqlUserWeb.User.update(id, Map.delete(params, :id))
  end

  def update_user_preferences(%{user_id: id} = params, _) do
    GraphqlUserWeb.User.update_user_preferences(id, Map.delete(params, :id))
  end
end