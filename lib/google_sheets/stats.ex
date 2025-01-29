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
    Repo.all(Attendance)
  end
end
