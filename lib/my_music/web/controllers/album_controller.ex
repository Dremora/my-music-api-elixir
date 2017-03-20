defmodule MyMusic.Web.AlbumController do
  use MyMusic.Web, :controller

  alias MyMusic.Library
  alias MyMusic.Library.Album

  action_fallback MyMusic.Web.FallbackController

  def index(conn, _params) do
    albums = Library.list_albums()
    render(conn, "index.json", albums: albums)
  end

  def create(conn, %{"album" => album_params}) do
    with {:ok, %Album{} = album} <- Library.create_album(album_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", album_path(conn, :show, album))
      |> render("show.json", album: album)
    end
  end

  def show(conn, %{"id" => id}) do
    album = Library.get_album!(id)
    render(conn, "show.json", album: album)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Library.get_album!(id)

    with {:ok, %Album{} = album} <- Library.update_album(album, album_params) do
      render(conn, "show.json", album: album)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Library.get_album!(id)
    with {:ok, %Album{}} <- Library.delete_album(album) do
      send_resp(conn, :no_content, "")
    end
  end
end