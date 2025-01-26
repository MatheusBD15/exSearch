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
end
