defmodule MyMusicWeb.Resolvers.Source do
  alias MyMusic.Repo
  alias MyMusic.Library.Source
  import Ecto.Query, only: [from: 2]

  def byAlbum(parent, _args, _info) do
    {:ok, Repo.all(from s in Source, where: s.album_id == ^parent.id, select: s)}
  end
end
