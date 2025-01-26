defmodule ExSearch.Page do
  require Logger
  alias ExSearch.Pages.Services

  def fetch_by_url(url) do
    Services.fetch_by_url(url)
  end

  def fetch_by_search_string(search) do
    Services.fetch_by_search_string(search)
  end

  def insert_page(page) do
    Services.insert_page(page)
  end

  def get_total_pages() do
    Services.get_total_pages()
  end

  def get_all_pages() do
    Services.get_all_pages()
  end

  def perform_page_rank_calculation() do
    Services.perform_page_rank_calculation()
  end

  def update_all_pages(pages) do
    Services.update_all_pages(pages)
  end
end
