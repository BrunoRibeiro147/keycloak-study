defmodule KeycloakStudy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      KeycloakStudy.Repo,
      # Start the Telemetry supervisor
      KeycloakStudyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: KeycloakStudy.PubSub},
      # Start the Endpoint (http/https)
      KeycloakStudyWeb.Endpoint,
      KeycloakStudyWeb.Authentication.OpenID.JWKS

      # Start a worker by calling: KeycloakStudy.Worker.start_link(arg)
      # {KeycloakStudy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KeycloakStudy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KeycloakStudyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
