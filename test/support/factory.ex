defmodule GraphqlUser.Factory do
  use ExMachina.Ecto, repo: GraphqlUser.Repo

  alias GraphqlUser.Accounts.{User, Preference}

  def user_factory do
    %User{
      name: "Test User",
      email: sequence(:email, &"user#{&1}@example.com"),
      preference: build(:preference)
    }
  end

  def preference_factory do
    %Preference{
      likes_emails: true,
      likes_phone_calls: false,
      likes_faxes: false
    }
  end
end
