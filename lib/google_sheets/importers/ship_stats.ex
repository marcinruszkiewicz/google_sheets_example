defmodule GoogleSheets.Importers.ShipStats do
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

    GoogleSheets.Repo.insert_all(GoogleSheets.Stats.FlownShip, results)

    :ok
  end

  defp data_range(sheet_name), do: "'#{sheet_name}'!E2:G"

  defp get_practice_data(sheet_name, conn, spreadsheet_id, year) do
    range = data_range(sheet_name)
    response = get_data(conn, spreadsheet_id, range)

    response.values
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.reject(fn row ->
      List.first(row) == "" || List.first(row) == "Our Ships" || Enum.count(row) == 1
    end)
    |> Enum.map(fn row ->
      Enum.reject(row, fn field -> field == "" end)
    end)
    |> Enum.map(fn row ->
      if Enum.count(row) == 2 do
        stat_record(row, sheet_name, year)
      else
        [
          stat_record([Enum.at(row, 0), Enum.at(row, 1)], sheet_name, year),
          stat_record([Enum.at(row, 0), Enum.at(row, 2)], sheet_name, year)
        ]
      end
    end)
    |> List.flatten()
  end

  defp stat_record(row, sheet_name, year) do
    date = practice_date(sheet_name, year)
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    %{
      name: Enum.at(row, 1),
      ship_name:
        row
        |> Enum.at(0)
        |> String.replace([" A", " B", " (flag)", " Y", " y"], "")
        |> String.trim(),
      practice_date: date,
      sheet_name: sheet_name,
      inserted_at: now,
      updated_at: now
    }
  end
end
