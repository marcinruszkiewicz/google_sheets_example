defmodule Mix.Tasks.Import.Ships do
  @shortdoc "import ship stats from google sheets"

  @moduledoc """
  Console task for importing the ship stats data.
  """
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: [sheet: :string, year: :integer])

    Mix.Task.run("app.start")

    GoogleSheets.Importers.ShipStats.process(parsed[:sheet], parsed[:year])
  end
end
