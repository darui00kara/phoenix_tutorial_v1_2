defmodule SampleApp.Repo.Migrations.CreateMicropost do
  use Ecto.Migration

  def change do
    create table(:microposts) do
      add :content, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:microposts, [:user_id])

  end
end
