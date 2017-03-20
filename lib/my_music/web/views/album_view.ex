defmodule MyMusic.Web.AlbumView do
  use MyMusic.Web, :view
  alias MyMusic.Web.AlbumView

  def render("index.json", %{albums: albums}) do
    %{albums: render_many(albums, AlbumView, "album.json")}
  end

  def render("show.json", %{album: album}) do
    %{album: render_one(album, AlbumView, "album.json")}
  end

  def render("album.json", %{album: album}) do
    %{id: album.id,
      title: album.title,
      artist: album.artist,
      comments: album.comments,
      year: album.year,
      first_played: cond do
        album.first_played_timestamp -> DateTime.to_unix(album.first_played_timestamp, :millisecond)
        album.first_played_date -> album.first_played_date
        true -> nil
      end,
      sources: render_many(album.sources, AlbumView, "source.json", as: :source)
    }
  end

  def render("source.json", %{source: source}) do
    %{id: source.id,
      accurate_rip: source.accurate_rip,
      comments: source.comments,
      discs: source.discs,
      download: source.download,
      edition: source.edition,
      format: source.format,
      location: source.location,
      mbid: source.mbid,
      tag_issues: source.tag_issues
    }
  end
end
