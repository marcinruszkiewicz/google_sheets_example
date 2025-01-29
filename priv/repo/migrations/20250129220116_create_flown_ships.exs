defmodule GoogleSheets.Repo.Migrations.CreateFlownShips do
  use Ecto.Migration

  def change do
    create table(:flown_ships) do
      add :name, :string
      add :ship_name, :string
      add :sheet_name, :string
      add :practice_date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
