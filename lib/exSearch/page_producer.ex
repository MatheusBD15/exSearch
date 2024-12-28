defmodule ExSearch.PageProducer do
  use GenStage
  require Logger

  @initial_url "https://minecraft.wiki/"

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) do
    Logger.info("PageProducer init")

    # kickstart the search with an initial url
    __MODULE__.scrape_urls([@initial_url])
    {:producer, initial_state}
  end

  def handle_demand(demand, state) do
    Logger.info("Received demand for #{demand} pages")
    events = []
    {:noreply, events, state}
  end

  def scrape_urls(urls) when is_list(urls) do
    GenStage.cast(__MODULE__, {:urls, urls})
  end

  def handle_cast({:urls, urls}, state) do
    {:noreply, urls, state}
  end
end
