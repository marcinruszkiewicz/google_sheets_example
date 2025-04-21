defmodule GoogleSheets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    credentials = "GCP_CREDENTIALS" |> System.fetch_env!() |> Jason.decode!()

    scopes = [
      "https://www.googleapis.com/auth/spreadsheets",
      "https://www.googleapis.com/auth/drive"
    ]

    source = {:service_account, credentials, scopes: scopes}

    children = [
      GoogleSheets.Repo,
      {DNSCluster, query: Application.get_env(:google_sheets, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GoogleSheets.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GoogleSheets.Finch},
      {Goth, name: GoogleSheets.Goth, source: source},
      # Start a worker by calling: GoogleSheets.Worker.start_link(arg)
      # {GoogleSheets.Worker, arg},
      # Start to serve requests, typically the last entry
      GoogleSheetsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GoogleSheets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GoogleSheetsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
