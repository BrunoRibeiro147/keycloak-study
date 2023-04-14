defmodule KeycloakStudyWeb.Authentication do
  @moduledoc """
  Behaviour that defines how we'll authenticate the Web API
  """

  @adapter Application.compile_env!(:keycloak_study, [__MODULE__, :adapter])

  @callback authenticate(authorization_header :: String.t()) ::
              {:ok, user_id :: Ecto.UUID.t()} | :error

  @spec authenticate(authorization_header :: String.t()) ::
          {:ok, user_id :: Ecto.UUID.t()} | :error

  defdelegate authenticate(authorization_header), to: @adapter
end
