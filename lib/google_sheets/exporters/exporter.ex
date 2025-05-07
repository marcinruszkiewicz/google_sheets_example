defmodule GoogleSheets.Exporters.Exporter do
  alias GoogleApi.Sheets.V4.Api.Spreadsheets
  alias GoogleApi.Drive.V3.Api.Permissions

  @callback process(String.t(), String.t()) :: {atom(), String.t()}

  @empty_row %{
    values: []
  }

  @title_row %{
    values: [
      %{userEnteredValue: %{stringValue: "Thumbs"}},
      %{},
      %{},
      %{userEnteredValue: %{stringValue: "Our Comps:"}},
      %{userEnteredValue: %{stringValue: "Set 1:"}},
      %{},
      %{userEnteredValue: %{stringValue: "Set 2:"}},
      %{},
      %{userEnteredValue: %{stringValue: "Set 3:"}},
      %{},
      %{userEnteredValue: %{stringValue: "Set 4:"}},
      %{},
      %{},
      %{userEnteredValue: %{stringValue: "Ship Feedback Notes"}}
    ]
  }

  @set_name_formulas %{
    1 => "=F1",
    2 => "=H1",
    3 => "=J1",
    4 => "=L1"
  }

  @matches [
    ["Match 1:"], 
    ["Match 2:"], 
    ["Match 3:"]
  ]

  def connect() do
    {:ok, token} = Goth.fetch(GoogleSheets.Goth)
    GoogleApi.Sheets.V4.Connection.new(token.token)
  end

  def create_sheet(conn, title, email) do
    with {:ok, %{spreadsheetId: spreadsheet_id} = spreadsheet} <-
           Spreadsheets.sheets_spreadsheets_create(conn, create_sheet_body(title)),
         {:ok, _permission} <-
           Permissions.drive_permissions_create(conn, spreadsheet_id,
             body: %{type: "user", role: "writer", emailAddress: email}
           ) do
        insert_data(conn, spreadsheet_id, "'! Practice Template'!K5", @matches)
        insert_data(conn, spreadsheet_id, "'! Practice Template'!K18", @matches)
        insert_data(conn, spreadsheet_id, "'! Practice Template'!K31", @matches)
        insert_data(conn, spreadsheet_id, "'! Practice Template'!K44", @matches)

        sheet = Enum.at(spreadsheet.sheets, 0)
        create_thumbs_counter(conn, spreadsheet_id, sheet.properties.sheetId)

      {:ok, %{spreadsheet: spreadsheet_id, template_sheet: sheet.properties.sheetId}}
    else
      {:error, error} ->
        IO.inspect(error, label: "error while creating spreadsheet:")
    end
  end

  defp create_sheet_body(title) do
    [
      body: %{
        properties: %{
          title: title,
          timeZone: "Europe/Paris"
        },
        sheets: [
          %{
            properties: %{
              title: "! Practice Template",
              gridProperties: %{
                frozenRowCount: 1
              }
            },
            data: %{
              rowData: [
                @title_row,
                @empty_row,
                set_number_row(1),
                set_titles_row(1),
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                set_number_row(2),
                set_titles_row(2),
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                set_number_row(3),
                set_titles_row(3),
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                @empty_row,
                set_number_row(4),
                set_titles_row(4)
              ]
            }
          }
        ]
      }
    ]
  end

  defp set_number_row(number) do
    %{
      values: [
        %{},
        %{},
        %{},
        %{userEnteredValue: %{stringValue: "Set #{number}"}},
        
      ]
    }
  end

  defp set_titles_row(number) do
    %{
      values: [
        %{},
        %{},
        %{},
        %{userEnteredValue: %{formulaValue: @set_name_formulas[number]}},
        %{userEnteredValue: %{stringValue: "Our Ships"}},
        %{userEnteredValue: %{stringValue: "Pilot"}},
        %{userEnteredValue: %{stringValue: "Alternate Pilot"}},
        %{},
        %{userEnteredValue: %{stringValue: "Hostile Ships"}},
        %{},
        %{userEnteredValue: %{stringValue: "Result"}},
        %{},
        %{userEnteredValue: %{stringValue: "Bans"}}
      ]
    }
  end

  def insert_data(conn, spreadsheet_id, range, values) do
    with {:ok, _} <- Spreadsheets.sheets_spreadsheets_values_update(conn, spreadsheet_id, range, valueInputOption: "raw", body: %{values: values}) do
      :ok
    else 
      {:error, error} -> 
        IO.inspect(error)
    end
  end

  defp update_cells(conn, spreadsheet_id, requests) do
    with {:ok, _} <- Spreadsheets.sheets_spreadsheets_batch_update(conn, spreadsheet_id, body: %{requests: requests}) do
      :ok
    else 
      {:error, error} -> 
        IO.inspect(error)
    end
  end

  defp create_thumbs_counter(conn, spreadsheet_id, sheet_id) do
    requests = [
      %{
        repeatCell: %{
          cell: %{userEnteredValue: %{formulaValue: "=countif('! Practice Template'!F:G,A2)"}},
          fields: "*",
          range: %{
            sheetId: sheet_id,
            startColumnIndex: 1,
            startRowIndex: 1,
            endRowIndex: 21,
            endColumnIndex: 2
          }
        }
      },
      %{
        addConditionalFormatRule: %{
          rule: %{
            ranges: [%{
              sheetId: sheet_id,
              startColumnIndex: 1,
              startRowIndex: 1,
              endRowIndex: 21,
              endColumnIndex: 2
            }],
            booleanRule: %{
              format: %{
                backgroundColor: %{
                  red: 0.91764706,
                  green: 0.6,
                  blue: 0.6
                }
              },
              condition: %{
                type: "NUMBER_LESS",
                values: [
                  %{userEnteredValue: "1"}
                ],
              }
            }
          }
        }
      },
      %{
        addConditionalFormatRule: %{
          rule: %{
            ranges: [%{
              sheetId: sheet_id,
              startColumnIndex: 1,
              startRowIndex: 1,
              endRowIndex: 21,
              endColumnIndex: 2
            }],
            booleanRule: %{
              format: %{
                backgroundColor: %{
                  red: 0.7176471,
                  green: 0.88235295,
                  blue: 0.8039216
                }
              },
              condition: %{
                type: "NUMBER_GREATER",
                values: [
                  %{userEnteredValue: "2"}
                ],
              }
            }
          }
        }
      }
    ]

    update_cells(conn, spreadsheet_id, requests)
  end

  def copy_sheet(conn, spreadsheet_id, sheet_id) do
    with {:ok, properties} <- Spreadsheets.sheets_spreadsheets_sheets_copy_to(conn, spreadsheet_id, sheet_id, body: %{destinationSpreadsheetId: spreadsheet_id}) do
      {:ok, properties}
    else 
      {:error, error} -> 
        IO.inspect(error)
    end
  end

  def rename_sheet(conn, spreadsheet_id, sheet_id, title) do
    requests = [
      %{
        updateSheetProperties: %{
          fields: "Title",
          properties: %{
            sheetId: sheet_id,
            title: title
          }
        }
      }
    ]

    update_cells(conn, spreadsheet_id, requests)
  end
end
