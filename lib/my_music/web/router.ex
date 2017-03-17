defmodule MyMusic.Web.Router do
  use MyMusic.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyMusic.Web do
    pipe_through :api
  end
end
