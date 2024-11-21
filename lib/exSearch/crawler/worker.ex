defmodule ExSearch.Crawler.Worker do
  @moduledoc """
  Crawler background worker
  """
  alias ExSearch.Crawler.Services

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(state) do
    Services.crawl_all_urls()
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:crawl, state) do
    Services.crawl_all_urls()
    schedule_work()
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end

  defp schedule_work() do
    # In 2 hours
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000)
  end
end
