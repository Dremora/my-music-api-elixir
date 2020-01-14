import Tirexs.Bulk
alias MyMusic.Library

defmodule Main do
  def main do
    commands =
      Enum.map(Library.list_albums(), fn album ->
        [
          id: album.id,
          artist: album.artist,
          title: album.title,
          year: album.year,
          first_played: case {album.first_played_date, album.first_played_timestamp} do
            {[year], nil} -> "#{year}"
            {[year, month], nil} -> "#{year}-#{month}"
            {[year, month, day], nil} -> "#{year}-#{month}-#{day}"
            {nil, %DateTime{} = timestamp} -> DateTime.to_unix(timestamp)
            {nil, nil} -> nil
            x -> raise "Unrecognized firstPlayed format: " <> inspect(x)
          end
        ]
      end)

    payload =
      bulk(index: "music") do
        index(commands)
      end

    {:ok, 200, _} = Tirexs.bump(payload)._bulk()
  end
end

Main.main()
