defmodule ExSearch.Repo do
  use Ecto.Repo,
    otp_app: :exSearch,
    adapter: Ecto.Adapters.Postgres
end
