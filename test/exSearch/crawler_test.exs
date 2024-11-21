defmodule ExSearch.CrawlerTest do
  use ExSearch.DataCase

  alias ExSearch.Crawler

  describe "urls" do
    alias ExSearch.Crawler.Url

    import ExSearch.CrawlerFixtures

    @invalid_attrs %{url: nil}

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert Crawler.list_urls() == [url]
    end

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert Crawler.get_url!(url.id) == url
    end

    test "create_url/1 with valid data creates a url" do
      valid_attrs = %{url: "some url"}

      assert {:ok, %Url{} = url} = Crawler.create_url(valid_attrs)
      assert url.url == "some url"
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crawler.create_url(@invalid_attrs)
    end

    test "update_url/2 with valid data updates the url" do
      url = url_fixture()
      update_attrs = %{url: "some updated url"}

      assert {:ok, %Url{} = url} = Crawler.update_url(url, update_attrs)
      assert url.url == "some updated url"
    end

    test "update_url/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = Crawler.update_url(url, @invalid_attrs)
      assert url == Crawler.get_url!(url.id)
    end

    test "delete_url/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %Url{}} = Crawler.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> Crawler.get_url!(url.id) end
    end

    test "change_url/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = Crawler.change_url(url)
    end
  end
end
