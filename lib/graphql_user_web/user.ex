defmodule GraphqlUserWeb.User do
  @users [%{
    id: 1,
    name: "Bill",
    email: "bill@gmail.com",
    preference: %{
      likes_emails: false,
      likes_phone_calls: true,
      likes_faxes: true
    }
  }, %{
    id: 2,
    name: "Alice",
    email: "alice@gmail.com",
    preference: %{
      likes_emails: true,
      likes_phone_calls: false,
      likes_faxes: true
    }
  }, %{
    id: 3,
    name: "Jill",
    email: "jill@hotmail.com",
    preference: %{
      likes_emails: true,
      likes_phone_calls: true,
      likes_faxes: false
    }
  }, %{
    id: 4,
    name: "Tim",
    email: "tim@gmail.com",
    preference: %{
      likes_emails: false,
      likes_phone_calls: false,
      likes_faxes: false
    }
  }]

  def all(params) when map_size(params) === 0 do
    {:ok, @users}
  end

  def all(params) do
    case Enum.filter(@users, fn user ->
      Enum.all?(params, fn {key, value} ->
        Map.get(user.preference, key) === value
      end)
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

  def update_user_preference(id, params) do
    case find(%{id: id}) do
      {:error, error} -> {:error, error}
      _user -> {:ok, params}
    end
  end
end
