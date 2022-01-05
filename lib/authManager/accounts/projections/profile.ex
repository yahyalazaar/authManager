defmodule AuthManager.Accounts.Projections.Profile do
  use Ecto.Schema

  @primary_key {:uuid, Ecto.UUID, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]
  @derive {Phoenix.Param, key: :uuid}
  schema "profiles" do
    # field(:uuid, Ecto.UUID)
    field(:address, :string)
    field(:is_admin, :boolean, default: false)
    field(:name, :string)
    field(:phone, :string)
    field(:role, :string)
    field(:zip, :string)
    field(:user_uuid, Ecto.UUID)
    field(:country, :string)
    field(:city, :string)
    timestamps()
  end
end
