defmodule PhxFormRelay.Repo.Migrations.AddNameToForms do
  use Ecto.Migration

  def change do
    alter table(:forms) do
      add :name, :text
    end
  end
end
