defmodule ExSearch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExSearchWeb.Telemetry,
      ExSearch.Repo,
      {DNSCluster, query: Application.get_env(:exSearch, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ExSearch.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ExSearch.Finch},
      # Start a worker by calling: ExSearch.Worker.start_link(arg)
      # {ExSearch.Worker, arg},
      # Start to serve requests, typically the last entry
      ExSearchWeb.Endpoint,
      {Task.Supervisor, name: ExSearch.CrawlerSupervisor},
      # crawler worker
      {ExSearch.Crawler.Worker, :none}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExSearch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExSearchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
