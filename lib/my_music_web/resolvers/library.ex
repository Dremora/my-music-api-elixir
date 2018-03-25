defmodule MyMusicWeb.Resolvers.Library do
  alias MyMusic.Library
  alias MyMusic.Repo

  def find_albums(_parent, %{query: query}, _info) do
    {:ok, Library.find_albums(query)}
  end

  def get_album(_parent, %{id: id}, _info) do
    case Library.get_album(id) do
      nil -> {:error, "Album id #{id} not found"}
      album -> {:ok, album}
    end
  end

  def create_album(params, _info) do
    case Library.create_album(params) do
      {:error, _} ->
        {:error, "Could not create album"}

      {:ok, _} = success ->
        success
    end
  end

  def update_album(params, _info) do
    case Library.update_album(params.id, params) do
      {:error, _} ->
        {:error, "Could not update album"}

      {:ok, _} = success ->
        success
    end
  end

  def delete_album(%{id: id}, _info) do
    Library.delete_album(id)
  end

  def sources_for_album(album, _, _) do
    query = Ecto.assoc(album, :sources)
    {:ok, Repo.all(query)}
  end
end
