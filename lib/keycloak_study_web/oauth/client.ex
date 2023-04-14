defmodule KeycloakStudyWeb.Oauth.Client do
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  def config do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: "myclient",
      client_secret: "wS7nVKCZ4XKZ0CQRLimsfZsjIouN9QBT",
      redirect_uri: "http://localhost:4000/auth/callback",
      site: "http://localhost:8080/auth",
      authorize_url: "/realms/myrealm/protocol/openid-connect/auth",
      token_url: "/realms/myrealm/protocol/openid-connect/token",
      serializers: %{"application/json" => Poison}
    )
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(config(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    OAuth2.Client.get_token!(
      config(),
      Keyword.merge(params, client_secret: config().client_secret)
    )
  end

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
