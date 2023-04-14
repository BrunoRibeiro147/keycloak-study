defmodule KeycloakStudyWeb.Authentication.Plug do
  @moduledoc """
  Plug for Auth
  """

  @behaviour Plug

  import Plug.Conn

  alias KeycloakStudyWeb.Authentication

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    with {:ok, authorization_header} <- get_authorization_header(conn),
         {:ok, user_id} <- Authentication.authenticate(authorization_header) do
      Map.update(conn, :assigns, %{}, &Map.merge(&1, %{"user_id" => user_id}))
    else
      :error ->
        conn
        |> send_resp(401, "Unauthorized")
        |> halt()
    end
  end

  def get_authorization_header(conn) do
    case get_req_header(conn, "authorization") do
      [header | _] -> {:ok, header}
      _ -> :error
    end
  end
end
