defmodule KeycloakStudyWeb.Authentication.OpenID.AccessToken do
  @moduledoc """
  AccessToken config for Joken
  """

  use Joken.Config

  @impl true
  def token_config do
    default_claims(iss: config()[:iss], aud: "myclient")
  end

  defp config do
    Application.fetch_env!(:keycloak_study, KeycloakStudyWeb.Authentication.OpenID)
  end
end
