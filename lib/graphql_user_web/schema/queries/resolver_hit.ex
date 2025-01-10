defmodule GraphqlUserWeb.Schema.Queries.ResolverHit do
  use Absinthe.Schema.Notation

  alias GraphqlUser.ResolverHitsAgent

  object :resolver_hit_queries do
    field :resolver_hits, :integer do
      resolve fn _, _ ->
        {:ok, ResolverHitsAgent.get_users_count}
      end
    end
  end
end
