defmodule UiWeb.Router do
  use UiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    #plug :accepts, ["json"]
    plug :accepts, ["application/openc2-cmd+json;version=1.0"]
  end

  scope "/", UiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", UiWeb do
  #   pipe_through :api
  # end
  scope "/openc2", UiWeb do
    pipe_through :api
    post "/", OC2Controller, :command
  end
end
