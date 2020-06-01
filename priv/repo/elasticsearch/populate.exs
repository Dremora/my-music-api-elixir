import Tirexs.Bulk
alias MyMusic.Library

defmodule Main do
  def main do
    commands = Enum.map(Library.list_albums(), &Library.to_elasticsearch/1)

    payload =
      bulk(index: "music") do
        index(commands)
      end

    {:ok, 200, _} = Tirexs.bump(payload)._bulk()
  end
end

Main.main()
