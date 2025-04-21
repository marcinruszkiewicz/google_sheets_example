defmodule GoogleSheets.Exporters.Exporter do
  alias GoogleApi.Sheets.V4.Api.Spreadsheets

  @callback process() :: {atom(), String.t()}

  def connect() do
    # setup json key in GCP_CREDENTIALS env
    {:ok, token} = Goth.fetch(GoogleSheets.Goth)
    GoogleApi.Sheets.V4.Connection.new(token.token)
  end

  def create_sheet(conn) do
    # {:ok, spreadsheet} = 
    Spreadsheets.sheets_spreadsheets_create(conn, properties: %{title: "Test Practice Tracker"}) |> IO.inspect
  end

  def sheet_info(conn) do
    # "1q02E-HVGPxKUgiCjnO0854vTGG36rwYexGJibI-Yxq4"
    Spreadsheets.sheets_spreadsheets_get(conn, "1KvL8U_-eBDGFcKV7Tu_KlA0w-uqR6c2KsTHkTSDjyfY") |> IO.inspect
  end
end
