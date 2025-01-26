defmodule ExSearch.Page do
  require Logger
  alias ExSearch.Pages.Repo

  def fetch_by_url(url) do
    Repo.fetch_by_url(url)
  end

  def fetch_by_search_string(search) do
    Repo.fetch_by_search_string(search)
  end

  def insert_page(page) do
    Repo.insert_page(page)
  end

  def get_total_pages() do
    case Repo.get_total() do
      {:reply, total} -> total
      error -> error
    end
  end
end
