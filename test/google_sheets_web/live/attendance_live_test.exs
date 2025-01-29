defmodule GoogleSheetsWeb.AttendanceLiveTest do
  use GoogleSheetsWeb.ConnCase

  import Phoenix.LiveViewTest
  import GoogleSheets.Factory

  defp create_attendance(_) do
    attendance = insert(:attendance)
    %{attendance: attendance}
  end

  describe "Index" do
    setup [:create_attendance]

    test "lists all attendances", %{conn: conn, attendance: attendance} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Attendance Stats"
      assert html =~ attendance.name
    end
  end
end
