defmodule AuthManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :uuid, primary_key: true
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:uuid])
    create unique_index(:users, [:email])
  end
end
