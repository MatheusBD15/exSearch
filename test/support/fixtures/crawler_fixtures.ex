defmodule ExSearch.CrawlerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExSearch.Crawler` context.
  """

  @doc """
  Generate a url.
  """
  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(%{
        url: "some url"
      })
      |> ExSearch.Crawler.create_url()

    url
  end
end
