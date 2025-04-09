defmodule GoogleSheets.Importers.Attendance do
  import GoogleSheets.Importers.Importer

  @behaviour GoogleSheets.Importers.Importer

  @impl true
  def process(spreadsheet_id, year) do
    conn = connect()

    results =
      conn
      |> sheets(spreadsheet_id)
      |> get_practice_names()
      |> Enum.flat_map(fn name ->
        name
        |> get_practice_data(conn, spreadsheet_id, year)
      end)

    GoogleSheets.Repo.insert_all(GoogleSheets.Stats.Attendance, results)

    :ok
  end

  defp data_range(sheet_name), do: "'#{sheet_name}'!A2:B"

  defp get_practice_data(sheet_name, conn, spreadsheet_id, year) do
    range = data_range(sheet_name)
    date = practice_date(sheet_name, year)
    response = get_data(conn, spreadsheet_id, range)
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    response.values
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.reject(fn row -> List.first(row) == "" end)
    |> Enum.map(fn row ->
      %{
        name: List.first(row),
        times_flown: row |> List.last() |> String.to_integer(),
        practice_date: date,
        sheet_name: sheet_name,
        inserted_at: now,
        updated_at: now
      }
    end)
  end
end
