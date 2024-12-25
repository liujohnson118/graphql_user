defmodule GraphqlUser.Repo do
  use Ecto.Repo,
    otp_app: :graphql_user,
    adapter: Ecto.Adapters.Postgres
end
