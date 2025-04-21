defmodule Mix.Tasks.Export.Practice do
  @shortdoc "import attendance from google sheets"

  @moduledoc """
  Console task for importing the attendance data.
  """
  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Mix.Task.run("app.start")

    {:ok, spreadsheet_id} = GoogleSheets.Exporters.PracticeTracker.process()
  end
end
