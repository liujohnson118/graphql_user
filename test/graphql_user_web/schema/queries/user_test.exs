defmodule GraphqlUserWeb.Schema.Queries.UserTest do
  use GraphqlUserWeb.DataCase, async: true
  #use Absinthe.Plug.Test

  alias GraphqlUserWeb.Schema
  alias GraphqlUser.Factory

  describe "user query" do
    setup do
      # Setup a user using the setup_users function
      user = setup_users() |> hd() # Assuming setup_users returns a list of users
      %{user: user}
    end

    test "returns a user by id", %{user: user} do
      query = """
      query GetUser($id: ID!) {
        user(id: $id) {
          id
          name
          email
        }
      }
      """
      variables = %{"id" => user.id}

      {:ok, %{data: user_found}} = Absinthe.run(query, Schema, variables: variables)
      assert user_found === %{
        "user" => %{
          "id" => to_string(user.id),
          "name" => user.name,
          "email" => user.email
        }
      }
    end

    test "returns nil for a non-existing user" do
      query = """
      query GetUser($id: ID!) {
        user(id: $id) {
          id
          name
          email
        }
      }
      """

      variables = %{"id" => -1}

      {:ok, %{data: user_data, errors: errors}} = Absinthe.run(query, Schema, variables: variables)
      assert user_data === %{"user" => nil}
      assert errors === [%{message: "User with id -1 not found", path: ["user"], locations: [%{line: 2, column: 3}]}]
    end
  end

  describe "users query" do
    setup do
      # Setup multiple users using setup_users
      users = setup_users()
      %{users: users}
    end

    test "returns all users when no filters are applied", %{users: users} do
      query = """
      query GetUsers {
        users {
          name
        }
      }
      """

      {:ok, %{data: %{"users" => users_data}}} = Absinthe.run(query, Schema)
      expected_names = users |> Enum.map(& &1.name)

      # Assert that the names of the users returned match the setup users
      user_names = Enum.map(users_data, fn %{"name" => name} -> name end)
      assert user_names == expected_names
    end

    test "returns users filtered by preferences", %{users: users} do
      query = """
      query GetUsers($likesEmails: Boolean, $likesPhoneCalls: Boolean, $likesFaxes: Boolean) {
        users(likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, likesFaxes: $likesFaxes) {
          name
        }
      }
      """

      variables = %{"likesEmails" => true, "likesPhoneCalls" => false, "likesFaxes" => true}

      {:ok, %{data: %{"users" => users_data}}} = Absinthe.run(query, Schema, variables: variables)
      assert users_data == [%{"name" => "Alice"}, %{"name" => "Bob"}]
    end

    test "returns users filtered by preferences with first filter", %{users: users} do
      query = """
      query GetUsers($likesEmails: Boolean, $likesPhoneCalls: Boolean, $likesFaxes: Boolean, $first: Int) {
        users(likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, likesFaxes: $likesFaxes, first: $first) {
          name
        }
      }
      """

      variables = %{"likesEmails" => true, "likesPhoneCalls" => false, "likesFaxes" => true, "first" => 1}

      {:ok, %{data: %{"users" => users_data}}} = Absinthe.run(query, Schema, variables: variables)
      assert users_data == [%{"name" => "Alice"}]
    end

    test "returns users filtered by preferences with after filter", %{users: users} do
      query = """
      query GetUsers($likesEmails: Boolean, $likesPhoneCalls: Boolean, $likesFaxes: Boolean, $after: Int) {
        users(likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, likesFaxes: $likesFaxes, after: $after) {
          name
        }
      }
      """
      first_user = Enum.find(users, fn user -> user.name == "Alice" end)
      variables = %{"likesEmails" => true, "likesPhoneCalls" => false, "likesFaxes" => true, "after" => first_user.id}

      {:ok, %{data: %{"users" => users_data}}} = Absinthe.run(query, Schema, variables: variables)
      assert users_data == [%{"name" => "Bob"}]
    end

    test "returns users filtered by preferences with before filter", %{users: users} do
      query = """
      query GetUsers($likesEmails: Boolean, $likesPhoneCalls: Boolean, $likesFaxes: Boolean, $before: Int) {
        users(likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, likesFaxes: $likesFaxes, before: $before) {
          name
        }
      }
      """
      second_user = Enum.find(users, fn user -> user.name == "Bob" end)
      variables = %{"likesEmails" => true, "likesPhoneCalls" => false, "likesFaxes" => true, "before" => second_user.id}

      {:ok, %{data: %{"users" => users_data}}} = Absinthe.run(query, Schema, variables: variables)
      assert users_data == [%{"name" => "Alice"}]
    end
  end
end
