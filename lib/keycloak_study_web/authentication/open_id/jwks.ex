defmodule KeycloakStudyWeb.Authentication.OpenID.JWKS do
  use GenServer

  alias KeycloakStudyWeb.Authentication.OpenID

  defmodule State do
    @moduledoc false

    defstruct [
      :openid_config,
      keys: %{}
    ]
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  @impl true
  def init(%State{} = state) do
    with {:ok, openid_config} <- OpenID.Discovery.load_config() do
      {:ok, %{state | openid_config: openid_config}}
    end
  end

  @impl true
  def handle_call(
        {:get_key, kid},
        _from,
        %State{keys: keys, openid_config: openid_config} = state
      ) do
    case fetch_or_refresh_keys(keys, kid, openid_config["jwks_uri"]) do
      {:ok, key} -> {:reply, {:ok, key}, state}
      {:error, refreshed_keys} -> handle_refreshed_keys(state, refreshed_keys, kid)
    end
  end

  def get_key(kid) do
    GenServer.call(__MODULE__, {:get_key, kid})
  end

  defp fetch_or_refresh_keys(keys, kid, jwks_uri) do
    IO.inspect(keys, label: "KEYS")

    case keys[kid] do
      nil ->
        refreshed_keys = OpenID.JWKS.Loader.load_keys(jwks_uri)
        {:error, refreshed_keys}

      key ->
        {:ok, key}
    end
  end

  defp handle_refreshed_keys(%State{} = state, refreshed_keys, kid) do
    new_state = %{state | keys: refreshed_keys}

    case refreshed_keys[kid] do
      nil -> {:reply, :error, new_state}
      key -> {:reply, {:ok, key}, new_state}
    end
  end
end
