defmodule PhxFormRelay.Repo.Migrations.AddReplyToToForms do
  use Ecto.Migration

  def change do
    alter table(:forms) do
      add :reply_to, :string
    end
  end
end
