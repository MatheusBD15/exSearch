defmodule ExSearchWeb.UrlController do
  use ExSearchWeb, :controller

  alias ExSearch.Crawler
  alias ExSearch.Crawler.Url

  def index(conn, _params) do
    urls = Crawler.list_urls()
    render(conn, :index, urls: urls)
  end

  def new(conn, _params) do
    changeset = Crawler.change_url(%Url{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"url" => url_params}) do
    case Crawler.create_url(url_params) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "Url created successfully.")
        |> redirect(to: ~p"/urls/#{url}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    url = Crawler.get_url!(id)
    render(conn, :show, url: url)
  end

  def edit(conn, %{"id" => id}) do
    url = Crawler.get_url!(id)
    changeset = Crawler.change_url(url)
    render(conn, :edit, url: url, changeset: changeset)
  end

  def update(conn, %{"id" => id, "url" => url_params}) do
    url = Crawler.get_url!(id)

    case Crawler.update_url(url, url_params) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "Url updated successfully.")
        |> redirect(to: ~p"/urls/#{url}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, url: url, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    url = Crawler.get_url!(id)
    {:ok, _url} = Crawler.delete_url(url)

    conn
    |> put_flash(:info, "Url deleted successfully.")
    |> redirect(to: ~p"/urls")
  end
end
