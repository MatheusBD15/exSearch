defmodule ExSearch.Pages.Page do
  defstruct [:url, :content, :backlinks, :forward_links, :rank, :title]
end
