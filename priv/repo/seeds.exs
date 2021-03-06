alias Ecto.Multi
alias Ecto.Changeset
alias Ecto.UUID
alias MyMusic.Repo
alias MyMusic.Library.Album

defmodule Main do
  def main do
    changesets =
      File.read!("priv/repo/seeds.json")
      |> Jason.decode!()
      |> Map.get("rows")
      |> Enum.map(&Map.get(&1, "doc"))
      |> Enum.filter(&(Map.get(&1, "_id") != "_design/rest"))
      |> Enum.map(&Main.album_cast/1)

    multi =
      changesets
      |> Enum.reduce(Multi.new(), fn cset, multi -> Multi.insert(multi, UUID.generate(), cset) end)

    {:ok, _} = Repo.transaction(multi)
  end

  def album_cast(params) do
    changeset = Album.changeset(%Album{}, params)
    Changeset.cast(changeset, %{id: UUID.generate()}, [:id])
  end
end

Main.main()
