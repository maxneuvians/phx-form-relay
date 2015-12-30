defmodule PhxFormRelay.Repo.Migrations.AddCcAndBccFieldsToForm do
  use Ecto.Migration

  def change do
    alter table(:forms) do
      add :cc, :text
      add :bcc, :text
    end
  end
end
