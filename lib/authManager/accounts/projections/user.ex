defmodule AuthManager.Accounts.Projections.User do
  use Ecto.Schema

  @primary_key {:uuid, Ecto.UUID, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]
  schema "users" do
    # field(:uuid, Ecto.UUID)
    field(:email, :string)
    field(:password_hash, :string)
    # Virtual fields:
    # field(:password, :string, virtual: true)
    # field(:password_confirmation, :string, virtual: true)
    timestamps()
  end
end
