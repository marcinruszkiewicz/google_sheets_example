defmodule GoogleSheets.Exporters.PracticeTracker do
  import GoogleSheets.Exporters.Exporter

  @behaviour GoogleSheets.Exporters.Exporter

  @set_player_fields %{
    1 => "F5",
    2 => "F18",
    3 => "F31",
    4 => "F44"
  }

  @set_ship_fields %{
    1 => "E5",
    2 => "E18",
    3 => "E31",
    4 => "E44"
  }

  @impl true
  def process(title, email) do
    all_players = Enum.map(1..10, fn _ -> Faker.Superhero.name() end)
    all_ships = Enum.map(1..20, fn _ -> Faker.Pokemon.name() end)

    conn = connect()
    {:ok, %{spreadsheet: spreadsheet_id, template_sheet: sheet_id}} = create_sheet(conn, title, email)

    Enum.map(1..3, fn _ -> 
      Faker.StarWars.planet()
    end)
    |> Enum.with_index(20)
    |> Enum.reverse
    |> Enum.each(fn {name, index} -> 
      title = "#{index} March - #{name}"
      {:ok, %{sheetId: copied_sheet_id}} = copy_sheet(conn, spreadsheet_id, sheet_id)
      rename_sheet(conn, spreadsheet_id, copied_sheet_id, title)
      
      thumbs = all_players |> Enum.map(fn name -> [name] end)
      insert_data(conn, spreadsheet_id, "'#{title}'!A2", thumbs)

      Enum.each(1..4, fn set_num -> 
        set_players = all_players |> Enum.shuffle() |> Enum.take(6) |> Enum.map(fn name -> [name] end)
        insert_data(conn, spreadsheet_id, "'#{title}'!#{@set_player_fields[set_num]}", set_players)

        set_ships = all_ships |> Enum.shuffle() |> Enum.take(6) |> Enum.map(fn name -> [name] end)
        insert_data(conn, spreadsheet_id, "'#{title}'!#{@set_ship_fields[set_num]}", set_ships)
      end)
    end)

    {:ok, spreadsheet_id}
  end
end
