defmodule ExSearch.PageConsumer do
  require Logger
  alias ExSearch.Page

  @max_number_of_pages 10

  def start_link(url) do
    # Logger.info("PageConsumer received url #{inspect(url)}")

    if Page.get_total_pages() < @max_number_of_pages do
      Task.start_link(fn ->
        ExSearch.Crawler.work(url)
      end)
    else
      Task.start_link(fn ->
        :ok
      end)
    end
  end
end
