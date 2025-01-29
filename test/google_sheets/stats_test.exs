defmodule GoogleSheets.StatsTest do
  use GoogleSheets.DataCase
  import GoogleSheets.Factory

  alias GoogleSheets.Stats

  test "list_attendances/0 returns all attendances" do
    attendance = insert(:attendance)
    assert Stats.list_attendances() == [attendance]
  end

  test "list_flown_ships/0 returns all flown_ships" do
    flown_ship = insert(:flown_ship)
    assert Stats.list_flown_ships() == [flown_ship]
  end
end
