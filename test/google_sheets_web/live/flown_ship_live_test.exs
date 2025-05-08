defmodule GoogleSheetsWeb.FlownShipLiveTest do
  use GoogleSheetsWeb.ConnCase

  import Phoenix.LiveViewTest
  import GoogleSheets.Factory

  defp create_flown_ship(_) do
    flown_ship = insert(:flown_ship)
    %{flown_ship: flown_ship}
  end

  describe "Index" do
    setup [:create_flown_ship]

    test "lists all flown_ships", %{conn: conn, flown_ship: flown_ship} do
      {:ok, _index_live, html} = live(conn, ~p"/ships")

      assert html =~ "Ship Stats"
      assert html =~ flown_ship.ship_name
    end
  end
end
