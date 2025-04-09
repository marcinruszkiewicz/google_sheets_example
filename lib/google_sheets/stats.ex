defmodule GoogleSheets.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias GoogleSheets.Repo

  alias GoogleSheets.Stats.Attendance
  alias GoogleSheets.Stats.FlownShip

  @doc """
  Returns the list of flown_ships.

  ## Examples

      iex> list_flown_ships()
      [%FlownShip{}, ...]

  """
  def list_flown_ships do
    Repo.all(FlownShip)
  end

  @doc """
  Returns the list of attendances.

  ## Examples

      iex> list_attendances()
      [%Attendance{}, ...]

  """
  def list_attendances do
    query =
      from a in Attendance,
        group_by: [a.name],
        select: %GoogleSheets.Stats.AttendanceView{
          id: a.name,
          name: a.name,
          matches: sum(a.times_flown),
          practices: count(a.times_flown),
          last_practice_date: max(a.practice_date),
          last_practice_name:
            fragment(
              "(ARRAY_AGG(? order by make_date(extract(year from current_date)::int, extract(month from to_date(?, 'dd Mon'))::int, extract(day from to_date(?, 'dd Mon'))::int) DESC))[1]",
              a.sheet_name,
              a.sheet_name,
              a.sheet_name
            )
        },
        order_by: [desc: sum(a.times_flown)]

    Repo.all(query)
  end
end
