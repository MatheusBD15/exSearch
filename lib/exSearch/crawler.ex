defmodule ExSearch.Crawler do
  require Logger
  alias ExSearch.PageProducer

  def work(url) do
    result_html = Req.get!(url).body

    {:ok, document} = Floki.parse_document(result_html)
    anchors = Floki.find(document, "a")

    title = document |> Floki.find("title") |> Floki.text()
    Logger.info("Scraped page with title #{title}")

    new_paths =
      Enum.map(anchors, fn anchor -> Enum.at(Floki.attribute(anchor, "href"), 0) end)

    new_urls =
      new_paths
      |> Enum.filter(fn path -> not is_nil(path) end)
      |> Enum.map(fn path ->
        case String.contains?(path, "https://") do
          true -> path
          false -> url <> String.slice(path, 1..-1//1)
        end
      end)
      |> Enum.uniq()

    PageProducer.scrape_urls(new_urls)
  end
end
