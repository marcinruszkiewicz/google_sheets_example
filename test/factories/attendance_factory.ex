defmodule GoogleSheets.AttendanceFactory do
  @moduledoc false

  alias GoogleSheets.Stats.Attendance

  defmacro __using__(_opts) do
    quote do
      def attendance_factory do
        %Attendance{
          name: "player name",
          times_flown: 5,
          practice_date: ~D[2024-11-22],
          sheet_name: "22 November - Brave"
        }
      end
    end
  end
end
