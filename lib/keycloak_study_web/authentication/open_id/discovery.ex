defmodule KeycloakStudyWeb.Authentication.OpenID.Discovery do
  @moduledoc """
  Loads OIDC configuration
  """

  use Tesla

  plug Tesla.Middleware.JSON

  def load_config do
    result = get("#{config()[:iss]}/.well-known/openid-configuration")

    case result do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      _ ->
        :error
    end
  end

  defp config do
    Application.fetch_env!(:keycloak_study, KeycloakStudyWeb.Authentication.OpenID)
  end
end
