defmodule ExSearch.PageProducer do
  use GenStage
  require Logger

  # this url can be anything at all
  # we are starting with the minecraft wiki
  @initial_url "https://minecraft.wiki/"

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) do
    # kickstart the search with an initial url
    __MODULE__.scrape_urls([@initial_url])

    # specify that the stage is a producer
    {:producer, initial_state}
  end

  # handle_demand is invoked when the consumer asks for events
  def handle_demand(num_pages, state) do
    Logger.info("Received demand for #{num_pages} urls")

    {:noreply, [], state}
  end

  # this function will allow external functions to call the producer and issue
  # requests for urls to be crawled
  def scrape_urls(urls) do
    GenStage.cast(__MODULE__, {:urls, urls})
  end

  def handle_cast({:urls, urls}, state) do
    {:noreply, urls, state}
  end
end
