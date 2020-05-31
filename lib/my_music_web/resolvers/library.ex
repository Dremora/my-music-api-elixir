defmodule MyMusicWeb.Resolvers.Library do
  alias Ecto.Changeset
  alias MyMusic.Library

  def find_albums(_parent, %{query: query}, _info) do
    {:ok, Library.find_albums(query)}
  end

  def find_album_per_year_count(_parent, _query, _info) do
    {:ok, Library.find_album_per_year_count()}
  end

  def find_album_per_first_played_year_count(_parent, _query, _info) do
    {:ok, Library.find_album_per_first_played_year_count()}
  end

  def get_album(_parent, %{id: id}, _info) do
    case Library.get_album(id) do
      nil -> {:error, "Album id #{id} not found"}
      album -> {:ok, album}
    end
  end

  def create_album(params, _info) do
    case Library.create_album(params) do
      {:error, changeset} ->
        {:error, message: "Could not create album", details: error_details(changeset)}

      {:ok, _} = success ->
        success
    end
  end

  def update_album(params, _info) do
    case Library.update_album(params.id, params) do
      {:error, changeset} ->
        {:error, message: "Could not update album", details: error_details(changeset)}

      {:ok, _} = success ->
        success
    end
  end

  def error_details(changeset) do
    changeset
    |> Changeset.traverse_errors(fn {msg, _} -> msg end)
  end

  def delete_album(%{id: id}, _info) do
    Library.delete_album(id)
  end
end
