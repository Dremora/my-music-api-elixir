defmodule MyMusicWeb.Router do
  use Phoenix.Router
  import Phoenix.Controller

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyMusicWeb do
    pipe_through :api

    resources "/albums", AlbumController, except: [:new, :edit]
  end
end
