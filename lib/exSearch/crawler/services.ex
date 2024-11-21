defmodule ExSearch.Crawler.Services do
  @moduledoc """
  Crawler services
  """

  import Ecto.Query, warn: false
  alias ElixirLS.LanguageServer.Providers.Completion.Reducers.Bitstring
  alias ExSearch.Repo

  alias ExSearch.Crawler.Url

  @doc """
  Returns the list of urls.

  ## Examples

      iex> list_urls()
      [%Url{}, ...]

  """
  def list_urls do
    Repo.all(Url)
  end

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!(123)
      %Url{}

      iex> get_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_url!(id), do: Repo.get!(Url, id)

  @doc """
  Creates a url.

  ## Examples

      iex> create_url(%{field: value})
      {:ok, %Url{}}

      iex> create_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url(attrs \\ %{}) do
    %Url{}
    |> Url.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a url.

  ## Examples

      iex> update_url(url, %{field: new_value})
      {:ok, %Url{}}

      iex> update_url(url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_url(%Url{} = url, attrs) do
    url
    |> Url.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a url.

  ## Examples

      iex> delete_url(url)
      {:ok, %Url{}}

      iex> delete_url(url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_url(%Url{} = url) do
    Repo.delete(url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url changes.

  ## Examples

      iex> change_url(url)
      %Ecto.Changeset{data: %Url{}}

  """
  def change_url(%Url{} = url, attrs \\ %{}) do
    Url.changeset(url, attrs)
  end

  def crawl_all_urls() do
    list_urls()
    |> Enum.each(fn url ->
      Task.Supervisor.async_nolink(ExSearch.CrawlerSupervisor, fn -> crawl_url(url.url) end)
    end)
  end

  def crawl_url(url) do
    result_html = Req.get!(url).body

    {:ok, document} = Floki.parse_document(result_html)
    anchors = Floki.find(document, "a")

    new_paths =
      Enum.map(anchors, fn anchor -> Enum.at(Floki.attribute(anchor, "href"), 0) end)

    new_urls =
      new_paths
      |> Enum.filter(fn path -> not is_nil(path) end)
      |> Enum.map(fn path ->
        case String.contains?(path, "https://") do
          true -> path
          false -> url <> String.slice(path, 1..-1//-1)
        end
      end)

    IO.inspect(new_urls)
  end
end
