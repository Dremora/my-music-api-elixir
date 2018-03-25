defmodule MyMusic.Library do
  import Ecto.{Query, Changeset}, warn: false
  import Tirexs.Bulk
  alias MyMusic.Repo

  alias MyMusic.Library.Album

  def list_albums do
    Repo.all(from a in Album, preload: :sources)
  end

  def find_albums(search_string) do
    query = [
      index: "music",
      type: "album",
      search: [
        from: 0,
        size: 50,
        query: [
          multi_match: [
            query: search_string,
            fields: ["artist", "title", "year"],
            lenient: true,
            type: "cross_fields",
            operator: "and"
          ]
        ]
      ]
    ]

    {:ok, 200, %{hits: %{hits: results}}} = Tirexs.Query.create_resource(query)
    ids = Enum.map(results, & &1._id)
    Repo.all(from a in Album, where: a.id in ^ids, preload: :sources)
  end

  def get_album(id) do
    Repo.get(Album, id)
  end

  defp index_album(album) do
    with {:ok, album} <- album do
      payload =
        bulk(index: "music", type: "album") do
          index([
            [
              id: album.id,
              artist: album.artist,
              title: album.title,
              year: album.year
            ]
          ])
        end

      {:ok, 200, _r} = Tirexs.bump(payload)._bulk()
    end

    album
  end

  def create_album(attrs \\ %{}) do
    %Album{}
    |> album_changeset(attrs)
    |> Repo.insert()
    |> index_album
  end

  def update_album(id, attrs) do
    album =
      Album
      |> Repo.get(id)
      |> Repo.preload(:sources)

    case album do
      nil ->
        {:error, "Album not found"}

      album ->
        album
        |> album_changeset(attrs)
        |> Repo.update()
        |> index_album
    end
  end

  def delete_album(id) do
    case Repo.get(Album, id) do
      nil ->
        {:error, "Album not found"}

      album ->
        result = Repo.delete(album)

        payload =
          bulk(index: "music", type: "album") do
            delete([
              [
                id: album.id
              ]
            ])
          end

        {:ok, 200, _r} = Tirexs.bump(payload)._bulk()
        result
    end
  end

  def album_changeset(%Album{} = album, attrs) do
    changes =
      album
      |> cast(attrs, [:artist, :title, :year, :comments])
      |> cast_assoc(:sources)
      |> validate_required([:artist, :title])
      |> validate_length(:artist, max: 255)
      |> validate_length(:title, max: 255)
      |> validate_length(:comments, max: 255)
      |> validate_inclusion(:year, 1900..2100)

    if Map.has_key?(attrs, "first_played") do
      cond do
        is_list(attrs["first_played"]) ->
          changes
          |> put_change(:first_played_timestamp, nil)
          |> cast(%{first_played_date: attrs["first_played"]}, [:first_played_date])
          |> validate_length(:first_played_date, min: 1, max: 3)

        is_integer(attrs["first_played"]) ->
          date = DateTime.from_unix!(attrs["first_played"], :millisecond)

          changes
          |> put_change(:first_played_date, nil)
          |> cast(%{first_played_timestamp: date}, [:first_played_timestamp])

        true ->
          add_error(changes, :first_played, "is invalid")
      end
    else
      changes
    end
  end
end
