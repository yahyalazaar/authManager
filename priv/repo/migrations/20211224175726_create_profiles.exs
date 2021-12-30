defmodule AuthManager.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string
      add :phone, :string
      add :role, :string
      add :is_admin, :boolean, default: false, null: false
      add :address, :text
      add :zip, :string
      add :city, :string
      add :country, :string
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:profiles, [:user_id])
  end
end
