import Tirexs.Bulk
alias MyMusic.Library

defmodule Main do
  def main do
    commands = Enum.map(Library.list_albums(), fn album ->
      [
        id: album.id,
        artist: album.artist,
        title: album.title,
        year: album.year
      ]
    end)
    payload = bulk([ index: "music", type: "album" ]) do
      index commands
    end
    Tirexs.bump(payload)._bulk()
  end
end

Main.main
