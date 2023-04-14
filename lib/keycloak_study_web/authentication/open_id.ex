defmodule KeycloakStudyWeb.Authentication.OpenID do
  @moduledoc """
  OpenID adapter for authentication
  """

  @behaviour KeycloakStudyWeb.Authentication

  alias KeycloakStudyWeb.Authentication.OpenID

  require Logger

  @impl true
  def authenticate(authorization_header) do
    with {:ok, access_token} <- get_access_token(authorization_header) do
      validate_token(access_token)
    end
  end

  defp validate_token(access_token) do
    case OpenID.AccessToken.verify_and_validate(access_token, signer(access_token))
         |> IO.inspect() do
      {:ok, %{"sub" => user_id}} ->
        {:ok, user_id}

      {:error, reason} ->
        Logger.info("User authentication failed", reason: inspect(reason))

        :error
    end
  end

  defp signer(access_token) do
    with {:ok, %{"alg" => alg, "kid" => kid}} <- Joken.peek_header(access_token),
         {:ok, key} <- OpenID.JWKS.get_key(kid) do
      Joken.Signer.create(alg, key)
    end
  end

  defp get_access_token("Bearer " <> access_token), do: {:ok, access_token}
  defp get_access_token(_), do: :error
end
