defmodule GraphqlUserWeb.Schema.Mutations.PreferenceTest do
  use GraphqlUserWeb.ConnCase, async: true

  alias EctoShorts.Actions
  alias GraphqlUser.Accounts.{User, Preference}
  alias GraphqlUser.Repo

  describe "preference mutations" do
    @update_user_preference_mutation """
    mutation UpdateUserPreference($userId: ID!, $likesEmails: Boolean, $likesPhoneCalls: Boolean, $likesFaxes: Boolean) {
      updateUserPreference(userId: $userId, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, likesFaxes: $likesFaxes) {
        userId
        likesEmails
        likesPhoneCalls
        likesFaxes
      }
    }
    """

    setup do
      # Ensure the database is clean before starting
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlUser.Repo)

      # Optionally return a setup map, if needed
      :ok
    end

    test "successfully updates a user", %{conn: conn} do
      {:ok, user} = Actions.create(
        User,
        %{
          name: "Doug",
          email: "doug@example.com",
          preference: %{
            likes_emails: true,
            likes_phone_calls: false,
            likes_faxes: true
          }
        }
      )

      variables = %{
        userId: user.id,
        likesEmails: false,
        likesPhoneCalls: true,
        likesFaxes: false
      }
      user_id = to_string(user.id)

      response =
        conn
        |> post("/graphql", %{query: @update_user_preference_mutation, variables: variables})
        |> json_response(200)

      assert %{
               "data" => %{
                 "updateUserPreference" => %{
                   "userId" => ^user_id,
                   "likesEmails" => false,
                   "likesPhoneCalls" => true,
                   "likesFaxes" => false
                 }
               }
             } = response

      updated_preference = Repo.get(Preference, user.preference.id)
      assert updated_preference.likes_emails === false
      assert updated_preference.likes_phone_calls === true
      assert updated_preference.likes_faxes === false
    end
  end
end
