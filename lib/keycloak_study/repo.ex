defmodule KeycloakStudy.Repo do
  use Ecto.Repo,
    otp_app: :keycloak_study,
    adapter: Ecto.Adapters.Postgres
end
