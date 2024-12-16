defmodule GraphqlUserWeb.Schema.Subscriptions.User do
  use Absinthe.Schema.Notation

  object :user_subscriptions do
    field :created_user, :user do
      trigger :create_user, topic: fn _ ->
        "new_user"
      end

      config fn _, _ ->
        {:ok, topic: "new_user"}
      end
    end

    field :updated_user_preferences, :preferences do
      arg :user_id, non_null(:id)
      trigger :update_user_preferences, topic: fn _ ->
        "updated_user_preferences"
      end

      config fn _,_ ->
        {:ok, topic: "updated_user_preferences"}
      end
    end
  end
end
