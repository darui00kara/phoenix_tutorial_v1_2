defmodule SampleApp.Repo.Migrations.AddPasswordClumnToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password, :string
      add :password_digest, :string, null: false
    end
  end
end
