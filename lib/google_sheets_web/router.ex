defmodule GoogleSheetsWeb.Router do
  use GoogleSheetsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GoogleSheetsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", GoogleSheetsWeb do
    pipe_through :browser

    live "/", AttendanceLive.Index, :index
    live "/ships", FlownShipLive.Index, :index
  end
end
