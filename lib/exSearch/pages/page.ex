defmodule ExSearch.Pages.Page do
  @moduledoc """
  The Page struct
  """
  defstruct [:url, :content, :backlinks, :forward_links, :rank, :title]
end
