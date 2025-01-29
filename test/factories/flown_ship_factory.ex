defmodule GoogleSheets.FlownShipFactory do
  @moduledoc false

  alias GoogleSheets.Stats.FlownShip

  defmacro __using__(_opts) do
    quote do
      def flown_ship_factory do
        %FlownShip{
          name: "player name",
          ship_name: "Bhargest",
          practice_date: ~D[2024-11-22],
          sheet_name: "Brave - Nov 11"
        }
      end
    end
  end
end
