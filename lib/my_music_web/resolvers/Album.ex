defmodule MyMusicWeb.Resolvers.Album do
  alias MyMusic.Library

  def find(_parent, %{query: query}, _info) do
    {:ok, Library.search(query)}
  end

  def find_one(_parent, %{id: id}, _info) do
    case Library.get_album(id) do
      nil -> {:error, "Album id #{id} not found"}
      album -> {:ok, album}
    end
  end

  def create(params, _info) do
    Library.create_album(params)
  end

  def update(params, _info) do
    Library.update_album(params.id, params)
  end

  def delete(%{id: id}, _info) do
    Library.delete_album(id)
  end
end
