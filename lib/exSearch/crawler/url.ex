defmodule ExSearch.Crawler.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
