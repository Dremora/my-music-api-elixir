defmodule MyMusic.Library do
  import Ecto.{Query, Changeset}, warn: false
  alias MyMusic.Repo

  alias MyMusic.Library.Album

  def list_albums do
    Repo.all(from a in Album, preload: :sources)
  end

  def get_album!(id) do
    Repo.one from album in Album,
      where: album.id == ^id,
      preload: [:sources]
  end

  def create_album(attrs \\ %{}) do
    %Album{}
    |> album_changeset(attrs)
    |> Repo.insert()
  end

  def update_album(%Album{} = album, attrs) do
    album
    |> album_changeset(attrs)
    |> Repo.update()
  end

  def delete_album(%Album{} = album) do
    Repo.delete(album)
  end

  def change_album(%Album{} = album) do
    album_changeset(album, %{})
  end

  defp album_changeset(%Album{} = album, attrs) do
    changes = album
    |> cast(attrs, [:artist, :title, :year, :comments])
    |> cast_assoc(:sources)
    |> validate_required([:artist, :title])

    IO.inspect attrs
    if Map.has_key?(attrs, "first_played") do
      cond do
        is_list(attrs["first_played"]) ->
          cast(changes, %{first_played_date: attrs["first_played"]},
            [:first_played_date, :first_played_timestamp])
        is_integer(attrs["first_played"]) ->
          date = DateTime.from_unix!(attrs["first_played"], :millisecond)
          cast(changes, %{first_played_timestamp: date},
            [:first_played_date, :first_played_timestamp])
        true ->
          changes
      end
    else
      changes
    end
  end
end
