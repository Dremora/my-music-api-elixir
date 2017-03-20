defmodule MyMusic.Web.Router do
  use Phoenix.Router
  import Phoenix.Controller

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyMusic.Web do
    pipe_through :api

    resources "/albums", AlbumController, except: [:new, :edit]
  end
end
