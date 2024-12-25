defmodule GraphqlUser.Accounts do
  alias GraphqlUser.Accounts.{User, Preference}
  alias GraphqlUser.Repo

  def create_user(attrs) do
    %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
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

  def get_users do
    {:ok, Repo.all(User)}
  end

  def create_preference(user, attrs) do
    %Preference{}
      |> Preference.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()
  end

  def update_preference(preference, attrs) do
    preference
      |> Preference.changeset(attrs)
      |> Repo.update()
  end
end
