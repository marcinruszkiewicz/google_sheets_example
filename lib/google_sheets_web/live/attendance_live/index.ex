defmodule GoogleSheetsWeb.AttendanceLive.Index do
  use GoogleSheetsWeb, :live_view

  alias GoogleSheets.Stats

  @impl true
  def mount(_params, _session, socket) do
    socket =
      stream(socket, :attendances, Stats.list_attendances())

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket =
      socket
      |> assign(:page_title, "Attendance stats")

    {:noreply, socket}
  end
end
