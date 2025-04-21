defmodule Mix.Tasks.Import.Attendance do
  @shortdoc "import attendance from google sheets"

  @moduledoc """
  Console task for importing the attendance data.
  """
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: [sheet: :string, year: :integer])
    Mix.Task.run("app.start")

    GoogleSheets.Importers.Attendance.process(parsed[:sheet], parsed[:year])
  end
end
