defmodule PhxFormRelay.Repo.Migrations.CreateEmail do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add :content, :text
      add :ip, :string
      add :form_id, :uuid

      timestamps
    end
    create index(:emails, [:form_id])

  end
end
