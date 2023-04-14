defmodule KeycloakStudyWeb.TestController do
  use KeycloakStudyWeb, :controller

  def test(conn, _params) do
    send_resp(conn, 200, "Ok")
  end
end
