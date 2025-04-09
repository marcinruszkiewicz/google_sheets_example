defmodule GoogleSheets.StatsTest do
  use GoogleSheets.DataCase
  import GoogleSheets.Factory

  alias GoogleSheets.Stats

  test "list_attendances/0 returns attendance stats" do
    insert(:attendance)

    assert Stats.list_attendances() == [
             %GoogleSheets.Stats.AttendanceView{
               id: "player name",
               last_practice_date: ~D[2024-11-22],
               last_practice_name: "22 November - Brave",
               matches: 5,
               name: "player name",
               practices: 1
             }
           ]
  end

  test "list_flown_ships/0 returns all flown_ships" do
    flown_ship = insert(:flown_ship)
    assert Stats.list_flown_ships() == [flown_ship]
  end
end
