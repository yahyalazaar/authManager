defmodule AuthManager.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :address, :string
    field :is_admin, :boolean, default: false
    field :name, :string
    field :phone, :string
    field :role, :string
    field :zip, :string
    field :user_id, :id
    field :country, :string
    field :city, :string
    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :phone, :role, :is_admin, :address, :zip, :country, :city, :user_id])
    |> validate_required([:name, :phone, :role, :is_admin, :address, :zip, :country, :city, :user_id])
  end
end
