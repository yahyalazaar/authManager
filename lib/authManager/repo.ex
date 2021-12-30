defmodule AuthManager.Repo do
  use Ecto.Repo,
    otp_app: :authManager,
    adapter: Ecto.Adapters.Postgres
end
