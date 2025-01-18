defmodule GraphqlUserWeb.Schema.Mutations.UserTest do
  use GraphqlUserWeb.ConnCase, async: true

  alias EctoShorts.Actions
  alias GraphqlUser.Accounts.{User, Preference}
  alias GraphqlUser.Repo

  describe "user mutations" do
    @create_user_mutation """
    mutation CreateUser($name: String!, $email: String!, $preference: PreferenceInput!) {
      createUser(name: $name, email: $email, preference: $preference) {
        id
        name
        email
        preference {
          likesEmails
          likesPhoneCalls
          likesFaxes
        }
      }
    }
    """

    @update_user_mutation """
    mutation UpdateUser($id: ID!, $name: String, $email: String) {
      updateUser(id: $id, name: $name, email: $email) {
        id
        name
        email
      }
    }
    """

    setup do
      # Ensure the database is clean before starting
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlUser.Repo)

      # Optionally return a setup map, if needed
      :ok
    end

    test "successfully creates a user", %{conn: conn} do
      variables = %{
        "name" => "Lee",
        "email" => "lee@example.com",
        "preference" => %{
          "likesEmails" => true,
          "likesPhoneCalls" => false,
          "likesFaxes" => true
        }
      }

      response =
        conn
        |> post("/graphql", %{query: @create_user_mutation, variables: variables})
        |> json_response(200)

      assert %{
               "data" => %{
                 "createUser" => %{
                   "name" => "Lee",
                   "email" => "lee@example.com",
                   "preference" => %{
                     "likesEmails" => true,
                     "likesPhoneCalls" => false,
                     "likesFaxes" => true
                   }
                 }
               }
             } = response

      # Ensure user was created in the database
      user = Repo.get_by(User, email: "lee@example.com") |> Repo.preload(:preference)
      assert user
      assert user.name === "Lee"
      assert user.email === "lee@example.com"
      preference = user.preference
      assert preference.likes_emails === true
      assert preference.likes_phone_calls === false
      assert preference.likes_faxes === true
    end

    test "successfully updates a user", %{conn: conn} do
      {:ok, user} = Actions.create(
        User,
        %{
          name: "Doug",
          email: "doug@example.com"
        }
      )

      variables = %{
        "id" => user.id,
        "name" => "Robert",
        "email" => "robert@example.com"
      }
      user_id = to_string(user.id)

      response =
        conn
        |> post("/graphql", %{query: @update_user_mutation, variables: variables})
        |> json_response(200)

      assert %{
               "data" => %{
                 "updateUser" => %{
                   "id" => ^user_id,
                   "name" => "Robert",
                   "email" => "robert@example.com"
                 }
               }
             } = response

      updated_user = Repo.get(User, user.id)
      assert updated_user.name == "Robert"
      assert updated_user.email == "robert@example.com"
    end
  end
end
