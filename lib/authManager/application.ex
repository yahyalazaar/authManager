defmodule AuthManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuthManager.App,
      # Start the Ecto repository
      AuthManager.Repo,
      # Start the Telemetry supervisor
      AuthManagerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AuthManager.PubSub},
      # Start the Endpoint (http/https)
      AuthManagerWeb.Endpoint,
      # Start a worker by calling: AuthManager.Worker.start_link(arg)
      # {AuthManager.Worker, arg}

      AuthManager.Accounts.Supervisor,
      AuthManager.Support.Unique
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
