defmodule GraphqlUserWeb.Resolver.Preference do
  alias GraphqlUser.Accounts

  def update(%{id: id} = params, _) do
    Accounts.update_preference(id, Map.delete(params, :id))
  end
end
