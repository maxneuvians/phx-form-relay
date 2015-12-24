defmodule PhxFormRelay.Repo.Migrations.CreateForm do
  use Ecto.Migration

  def change do
    create table(:forms, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :to, :text
      add :honeypot, :string
      add :redirect_to, :string
      add :active, :boolean, default: false
      add :count, :integer, default: 0

      timestamps
    end

  end
end
