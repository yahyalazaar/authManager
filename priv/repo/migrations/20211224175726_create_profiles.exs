defmodule AuthManager.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :phone, :string
      add :role, :string
      add :is_admin, :boolean, default: false, null: false
      add :address, :text
      add :zip, :string
      add :city, :string
      add :country, :string
      add :user_uuid, references(:users, column: :uuid, type: :uuid, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:profiles, [:user_uuid])
  end
end
