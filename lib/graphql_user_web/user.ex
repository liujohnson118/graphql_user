defmodule GraphqlUserWeb.User do
  @users [%{
    id: 1,
    name: "Bill",
    email: "bill@gmail.com",
    preferences: %{
      likes_emails: false,
      likes_phone_calls: true,
      likes_faxes: true
    }
  }, %{
    id: 2,
    name: "Alice",
    email: "alice@gmail.com",
    preferences: %{
      likes_emails: true,
      likes_phone_calls: false,
      likes_faxes: true
    }
  }, %{
    id: 3,
    name: "Jill",
    email: "jill@hotmail.com",
    preferences: %{
      likes_emails: true,
      likes_phone_calls: true,
      likes_faxes: false
    }
  }, %{
    id: 4,
    name: "Tim",
    email: "tim@gmail.com",
    preferences: %{
      likes_emails: false,
      likes_phone_calls: false,
      likes_faxes: false
    }
  }]

  def all(params) do
    likes_emails = Map.get(params, :likes_emails, nil)
    likes_phone_calls = Map.get(params, :likes_phone_calls, nil)
    likes_faxes = Map.get(params, :likes_faxes, nil)
    case Enum.filter(@users, fn user ->
      preferences = user.preferences
      preferences[:likes_emails] === likes_emails &&
      preferences[:likes_phone_calls] === likes_phone_calls &&
      preferences[:likes_faxes] === likes_faxes
    end) do
      [] -> {:error, %{message: "not found", details: %{params: params}}}
      users -> {:ok, users}
    end
  end

  def find(%{id: id}) do
    id = String.to_integer(id)
    case Enum.find(@users, &(&1.id === id)) do
      nil -> {:error, %{message: "not found", details: %{id: id}}}
      user -> {:ok, user}
    end
  end

  def create(params) do
    {:ok, params}
  end

  def update(id, params) do
    with {:ok, user} <- find(%{id: id}) do
      {:ok, Map.merge(user, params)}
    end
  end

  def update_user_preferences(id, params) do
    user = find(%{id: id})
    if(user) do
      {:ok, params}
    else
      {:error, %{message: "not found", details: %{id: id}}}
    end
  end
end
