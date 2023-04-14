defmodule KeycloakStudyWeb.AuthController do
  use KeycloakStudyWeb, :controller

  alias KeycloakStudyWeb.Oauth.Client

  def index(conn, _params) do
    redirect(conn, external: Client.authorize_url!())
  end

  def callback(conn, %{"code" => code}) do
    client = Client.get_token!(code: code)

    IO.inspect(client, label: "CLIENT TOKEN")

    %{body: user} = OAuth2.Client.get!(client, "/realms/myrealm/protocol/openid-connect/userinfo")

    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/")
  end
end
