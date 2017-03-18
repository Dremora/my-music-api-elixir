defmodule MyMusic.Web.Router do
  use Phoenix.Router
  import Phoenix.Controller

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyMusic.Web do
    pipe_through :api
  end
end
