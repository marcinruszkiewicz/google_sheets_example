defmodule GoogleSheets.Exporters.PracticeTracker do
  import GoogleSheets.Exporters.Exporter

  @behaviour GoogleSheets.Exporters.Exporter

  @impl true
  def process do
    conn = connect()

    # create_sheet(conn)

    sheet_info(conn)
  end
end
