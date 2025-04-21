defmodule GoogleSheetsWeb.FlownShipLive.Index do
  use GoogleSheetsWeb, :live_view

  alias GoogleSheets.Stats

  @impl true
  def mount(_params, _session, socket) do
    socket =
      stream(socket, :flown_ships, Stats.list_ship_stats())

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket =
      socket
      |> assign(:page_title, "Flown ships")

    {:noreply, socket}
  end
end
