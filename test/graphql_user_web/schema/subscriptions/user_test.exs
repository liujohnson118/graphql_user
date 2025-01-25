defmodule GraphqlUserWeb.SubscriptionTest do
  use GraphqlUserWeb.SubscriptionCase

  alias GraphqlUser.Factory

  describe "user subscriptions" do
    setup do
      {:ok, user: Factory.insert(:user)}
    end

    test "receives a created_user subscription event", %{socket: socket} do
      # Subscribe to the "created_user" subscription
      ref = push_doc(socket, """
      subscription {
        createdUser {
          id
          name
          email
        }
      }
      """)
      assert_reply ref, :ok, reply
      IO.inspect(reply)

      # Trigger the create_user mutation
      mutation = """
      mutation {
        createUser(
          name: "Alice",
          email: "alice@example.com",
          preference: { likesEmails: true, likesPhoneCalls: false, likesFaxes: true }
        ) {
          id
          name
          email
        }
      }
      """
      # ref = push_doc(socket, mutation)

      # assert_reply ref, :ok, reply

      # IO.inspect(reply)
      # Assert the subscription receives the broadcasted event
      # assert_subscription socket, subscription_id, fn payload ->
      #   assert payload.result.data["createdUser"]["name"] == "Alice"
      #   assert payload.result.data["createdUser"]["email"] == "alice@example.com"
      # end
    end

    # test "receives an updated_user_preference subscription event", %{socket: socket, user: user} do
    #   # Subscribe to the "updated_user_preference" subscription
    #   ref = push_doc(socket, """
    #   subscription {
    #     updatedUserPreference(userId: #{user.id}) {
    #       id
    #       likesEmails
    #       likesPhoneCalls
    #       likesFaxes
    #     }
    #   }
    #   """)

    #   assert_reply ref, :ok, %{subscriptionId: subscription_id}

    #   # Trigger the update_user_preference mutation
    #   mutation = """
    #   mutation {
    #     updateUserPreference(
    #       userId: #{user.id},
    #       likesEmails: false,
    #       likesPhoneCalls: true,
    #       likesFaxes: false
    #     ) {
    #       id
    #       likesEmails
    #       likesPhoneCalls
    #       likesFaxes
    #     }
    #   }
    #   """
    #   ref = push_doc(socket, mutation)

    #   assert_reply ref, :ok, _response

    #   # Assert the subscription receives the broadcasted event
    #   assert_subscription socket, subscription_id, fn payload ->
    #     assert payload.result.data["updatedUserPreference"]["likesEmails"] == false
    #     assert payload.result.data["updatedUserPreference"]["likesPhoneCalls"] == true
    #     assert payload.result.data["updatedUserPreference"]["likesFaxes"] == false
    #   end
    # end
  end
end
