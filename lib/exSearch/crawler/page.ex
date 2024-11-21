defmodule ExSearch.Crawler.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :url, :string
    field :title, :string
    field :html, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:url, :title, :html])
    |> validate_required([:url, :html])
  end
end
