defmodule SampleApp.Repo.Migrations.CreateRelationship do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create table(:relationships) do
      add :follower_id, references(:users, on_delete: :nothing), null: false
      add :followed_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:relationships, [:follower_id], concurrently: true)
    create index(:relationships, [:followed_id], concurrently: true)
    create index(:relationships, [:follower_id, :followed_id], unique: true, concurrently: true)
  end
end
