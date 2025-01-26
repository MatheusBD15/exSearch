defmodule ExSearch.Pages.Services do
  require Logger
  alias ExSearch.Pages.Repo

  @constant 0.7
  @rating_source_factor 0.4

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

  def get_all_pages() do
    case Repo.get_all_pages() do
      {:reply, all_pages} -> all_pages
      error -> error
    end
  end

  def update_all_pages(pages) do
    Repo.update_all_pages(pages)
  end

  def perform_page_rank_calculation() do
    calculate_backlinks()

    all_pages = get_all_pages()

    %{pages_acc: updated_pages} =
      Enum.reduce_while(all_pages, %{pages_acc: all_pages, num_runs: 0}, fn _page,
                                                                            %{
                                                                              num_runs: num_runs,
                                                                              pages_acc: pages_acc
                                                                            } ->
        new_pages = calculate_page_rank(pages_acc)

        if num_runs > 100 do
          {:halt, %{pages_acc: new_pages, num_runs: num_runs}}
        else
          {:cont, %{pages_acc: new_pages, num_runs: num_runs + 1}}
        end
      end)

    pages_map =
      Enum.reduce(updated_pages, %{}, fn page, acc ->
        Map.put(acc, page.url, page)
      end)

    update_all_pages(pages_map)
  end

  defp calculate_page_rank(pages_acc) do
    for page <- pages_acc do
      starting_rank = @rating_source_factor

      rank =
        Enum.reduce(
          page.backlinks,
          starting_rank,
          fn backlink, acc ->
            backlinked_page = fetch_by_url(backlink)
            acc + backlinked_page.rank + length(backlinked_page.forward_links)
          end
        )

      new_rank = @constant * rank
      Map.put(page, :rank, new_rank)
    end
  end

  defp calculate_backlinks() do
    get_all_pages()
    |> Enum.map(&reset_page_backlink/1)
    |> Enum.map(&calculate_page_backlinks/1)
  end

  defp reset_page_backlink(page) do
    Map.put(page, :backlinks, [])
  end

  defp calculate_page_backlinks(page) do
    case length(page.forward_links) do
      0 ->
        page

      _ ->
        for forward_link <- page.forward_links do
          insert_backlink_in_forward_linked(page, forward_link)
          page
        end
    end
  end

  defp insert_backlink_in_forward_linked(page, forward_link) do
    forward_linked = fetch_by_url(forward_link)

    if forward_linked do
      new_forward_linked =
        Map.put(forward_linked, :backlinks, [page.url | forward_linked.backlinks])

      insert_page(new_forward_linked)
    end
  end
end
