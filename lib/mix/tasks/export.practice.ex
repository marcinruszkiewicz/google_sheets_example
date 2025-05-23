defmodule Mix.Tasks.Export.Practice do
  @shortdoc "generate attendance data and save it to google sheets"

  @moduledoc """
  Console task for exporting the attendance data.
  """
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: [email: :string, title: :string])
    Mix.Task.run("app.start")

    {:ok, spreadsheet_id} = GoogleSheets.Exporters.PracticeTracker.process(parsed[:title], parsed[:email])

    IO.puts("You can use the following spreadsheet id for importing: #{spreadsheet_id}")
  end
end
