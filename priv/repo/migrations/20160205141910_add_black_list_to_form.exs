defmodule PhxFormRelay.Repo.Migrations.AddBlackListToForm do
  use Ecto.Migration

  def change do
    alter table(:forms) do
      add :black_list, :text
    end
  end
end
