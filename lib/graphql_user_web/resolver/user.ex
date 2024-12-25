defmodule GraphqlUserWeb.Resolver.User do
  alias GraphqlUser.Accounts

  def all(params) do
    Accounts.get_users()
  end

  def find(%{id: id}) do
    Accounts.get_user(id)
  end

  def create(params, _) do
    Accounts.create_user(params)
  end

  def update(%{id: id} = params, _) do
    Accounts.update_user(id, Map.delete(params, :id))
  end
end
