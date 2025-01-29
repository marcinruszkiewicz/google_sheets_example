defmodule GoogleSheets.Stats.FlownShip do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flown_ships" do
    field :name, :string
    field :ship_name, :string
    field :sheet_name, :string
    field :practice_date, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(flown_ship, attrs) do
    flown_ship
    |> cast(attrs, [:name, :ship_name, :sheet_name, :practice_date])
    |> validate_required([:name, :ship_name, :sheet_name, :practice_date])
  end
end
