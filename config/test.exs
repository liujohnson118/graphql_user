import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graphql_user, GraphqlUserWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "q1vaxmOw5zpGyrEft6lXycUzsGZlN2KU2wkCr8+3ktjnYRHo+lDGYDh1NcaPE4j0",
  server: false

# In test we don't send emails
config :graphql_user, GraphqlUser.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :graphql_user, GraphqlUser.Repo,
  username: "postgres",       # Update with your database username
  password: "postgres",       # Update with your database password
  database: "graphql_user_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
