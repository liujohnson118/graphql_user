defmodule GraphqlUserWeb.DataCase do
  alias EctoShorts.Actions
  use ExUnit.CaseTemplate
  alias GraphqlUser.Accounts.{User, Preference}

  using do
    quote do
      alias GraphqlUser.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import GraphqlUser.Factory

      # Additional imports for test helpers
      import GraphqlUserWeb.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlUser.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(GraphqlUser.Repo, {:shared, self()})
    end

    :ok
  end

  def setup_users do
    {:ok, user1} = Actions.create(
      User,
      %{
        name: "Alice",
        email: "alice@example.com",
        preference: %{
          likes_emails: true,
          likes_phone_calls: false,
          likes_faxes: true
        }
      }
    )
    {:ok, user2} = Actions.create(
      User,
      %{
        name: "Bob",
        email: "bob@example.com",
        preference: %{
          likes_emails: true,
          likes_phone_calls: false,
          likes_faxes: true
        }
      })
    {:ok, user3} = Actions.create(
      User,
      %{
        name: "Charlie",
        email: "charlie@example.com",
        preference: %{
          likes_emails: true,
          likes_phone_calls: true,
          likes_faxes: true
        }
      })

    [user1, user2, user3]
  end
end
