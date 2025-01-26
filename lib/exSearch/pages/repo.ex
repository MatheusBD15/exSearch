defmodule ExSearch.Pages.Repo do
  alias ExSearch.Pages.Page
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
  def handle_cast({:insert_page, %Page{url: url} = page}, state) do
    Logger.info("Pages.Repo inserting page with url #{url}")
    {:noreply, Map.put(state, url, page)}
  end

  @impl true
  def handle_call({:lookup_page, url}, _from, state) do
    {:reply, state[url], state}
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

  def insert_page(%Page{} = page) do
    GenServer.cast(__MODULE__, {:insert_page, page})
  end
end
