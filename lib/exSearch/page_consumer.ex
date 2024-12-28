defmodule ExSearch.PageConsumer do
  require Logger

  def start_link(url) do
    Logger.info("PageConsumer received #{inspect(url)}")

    Task.start_link(fn ->
      ExSearch.Crawler.work(url)
    end)
  end
end
