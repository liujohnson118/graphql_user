defmodule GraphqlUserWeb.Schema.Queries.ResolverHit do
  use Absinthe.Schema.Notation

  alias GraphqlUser.ResolverHitsAgent

  object :resolver_hit_queries do
    field :resolver_hits, :integer do
      arg :key, non_null(:string)

      resolve fn params, _ ->
        {:ok, ResolverHitsAgent.get(params.key)}
      end
    end
  end
end
