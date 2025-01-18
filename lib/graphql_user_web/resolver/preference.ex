defmodule GraphqlUserWeb.Resolver.Preference do
  alias GraphqlUser.Accounts
  alias GraphqlUser.Accounts.Preference
  alias GraphqlUser.Repo


  def update_user_preference(%{user_id: user_id} = params, _) do
    preference_id = Repo.get_by(Preference, user_id: user_id).id
    Accounts.update_preference(preference_id, Map.delete(params, :user_id))
  end
end
