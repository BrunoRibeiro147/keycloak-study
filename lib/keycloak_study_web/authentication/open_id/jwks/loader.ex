defmodule KeycloakStudyWeb.Authentication.OpenID.JWKS.Loader do
  @moduledoc """
  Loads JWK keys
  """

  use Tesla

  plug Tesla.Middleware.JSON

  def load_keys(jwks_uri) do
    result = get(jwks_uri)

    case result do
      {:ok, %Tesla.Env{status: 200, body: body}} -> build_jwk_map(body)
      _ -> :error
    end
  end

  defp build_jwk_map(%{"keys" => keys}), do: Map.new(keys, &{&1["kid"], &1})
  defp build_jwk_map(%{"kty" => _, "kid" => kid} = key), do: %{kid => key}
end
