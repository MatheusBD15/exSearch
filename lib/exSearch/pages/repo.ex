defmodule ExSearch.Pages.Repo do
  @moduledoc """
  Pages Repo genServer, stores pages in a Map, indexed by url
  """
  require Logger

  use GenServer

  def start_link(opts) do
    Logger.info("Starting Pages.Repo")
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:insert_page, %{url: url} = page}, state) do
    Logger.info("Pages.Repo inserting page with url #{url}")
    {:noreply, Map.put(state, url, page)}
  end

  @impl true
  def handle_cast({:update_all_pages, new_state}, _old_state) do
    Logger.info("Updating all pages")
    {:noreply, new_state}
  end

  @impl true
  def handle_call({:lookup_page, url}, _from, state) do
    {:reply, state[url], state}
  end

  @impl true
  def handle_call(:get_total, _from, state) do
    {:reply, length(Map.keys(state)), state}
  end

  @impl true
  def handle_call(:get_all_pages, _from, state) do
    {:reply, Map.values(state), state}
  end

  @impl true
  def handle_call({:fetch_by_search_string, search}, _from, state) do
    sorted_result =
      state
      |> Enum.filter(fn {_url, page} -> String.contains?(page.content, search) end)
      |> Enum.sort(fn {_url1, page1}, {_url2, page2} ->
        page1.rank >= page2.rank
      end)

    {:reply, sorted_result, state}
  end

  def fetch_by_url(url) do
    GenServer.call(__MODULE__, {:lookup_page, url})
  end

  def fetch_by_search_string(search) do
    GenServer.call(__MODULE__, {:fetch_by_search_string, search})
  end

  def insert_page(page) do
    GenServer.cast(__MODULE__, {:insert_page, page})
  end

  def update_all_pages(pages) do
    GenServer.cast(__MODULE__, {:update_all_pages, pages})
  end

  def get_total() do
    GenServer.call(__MODULE__, :get_total)
  end

  def get_all_pages() do
    GenServer.call(__MODULE__, :get_all_pages)
  end
end
