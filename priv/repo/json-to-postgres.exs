alias Ecto.Multi
alias Ecto.Changeset
alias Ecto.UUID
alias MyMusic.Repo
alias MyMusic.Library.Album

defmodule Main do
  def main do
    changesets = Application.get_env(:my_music, :albums_json)
    |> File.read!
    |> Poison.Parser.parse!
    |> Map.get("rows")
    |> Enum.map(&(Map.get(&1, "doc")))
    |> Enum.map(&Main.album_cast/1)

    multi =
      changesets
      |> Enum.reduce(Multi.new, fn(cset, multi) -> Multi.insert(multi, UUID.generate, cset) end)

    {:ok, _} = Repo.transaction(multi)
  end

  def album_cast(params) do
    changeset = Album.changeset(%Album{}, params)
    {:ok, uuid} = UUID.load(Base.decode16!(params["_id"], case: :lower))
    Changeset.cast(changeset, %{id: uuid}, [:id])
  end
end

Main.main
