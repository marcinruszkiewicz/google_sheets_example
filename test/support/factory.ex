defmodule GoogleSheets.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: GoogleSheets.Repo
  use GoogleSheets.AttendanceFactory
  use GoogleSheets.FlownShipFactory
end
