defmodule ExSearch.Crawler do
  require Logger
  alias ExSearch.PageProducer

  def work(url) do
    # download the html
    result_html = Req.get!(url).body

    # parse the document with floki
    {:ok, document} = Floki.parse_document(result_html)

    # find all anchor elements
    anchors = Floki.find(document, "a")

    # get the document title
    title = document |> Floki.find("title") |> Floki.text()
    Logger.info("Scraped page with title #{title}")

    # get the href of all anchors
    all_hrefs =
      Enum.map(anchors, fn anchor -> Enum.at(Floki.attribute(anchor, "href"), 0) end)

    new_urls =
      all_hrefs
      # filter empty hrefs
      |> Enum.filter(fn path -> not is_nil(path) end)
      # filter anchors on the same page
      |> Enum.filter(fn path -> not String.contains?(path, "#") end)
      |> Enum.map(fn path ->
        case String.contains?(path, "https://") do
          true -> path
          false -> url <> String.slice(path, 1..-1//1)
        end
      end)
      # remove duplicates
      |> Enum.uniq()

    PageProducer.scrape_urls(new_urls)
  end
end
