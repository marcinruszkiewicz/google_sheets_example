defmodule GoogleSheets.Importers.Importer do
  alias GoogleApi.Sheets.V4.Api.Spreadsheets

  @callback process(spreadsheet_id :: String.t(), year :: integer()) ::
              atom()

  def connect() do
    {:ok, token} = Goth.fetch(GoogleSheets.Goth)
    GoogleApi.Sheets.V4.Connection.new(token.token)
  end

  def sheets(conn, spreadsheet_id) do
    {:ok, response} = Spreadsheets.sheets_spreadsheets_get(conn, spreadsheet_id)
    response.sheets
  end

  def get_practice_names(sheets) do
    sheets
    |> Enum.map(fn sheet -> sheet.properties.title end)
    |> Enum.reject(fn title -> String.starts_with?(title, "!") end)
  end

  def practice_date(sheet_name, year) do
    sheet_name
    |> String.split(" -")
    |> List.first()
    |> Timex.parse!("{D} {Mfull}")
    |> Timex.set(year: year)
    |> Timex.to_date()
  end

  def get_data(conn, spreadsheet_id, range) do
    {:ok, response} =
      Spreadsheets.sheets_spreadsheets_values_get(conn, spreadsheet_id, range)

    response
  end
end
