defmodule MyMusic.Library do
  import Ecto.{Query, Changeset}, warn: false
  import Tirexs.Bulk
  alias MyMusic.Repo

  alias MyMusic.Library.Album
  alias MyMusic.Library.Source

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(Source, _) do
    Source |> order_by(:id)
  end

  def query(queryable, _) do
    queryable
  end

  def list_albums do
    Repo.all(from(a in Album))
  end

  def find_album_per_year_count do
    query = [
      size: 0,
      aggs: [
        year_count: [
          terms: [
            field: "year",
            size: 200,
            missing: 0
          ]
        ]
      ]
    ]

    result = Tirexs.HTTP.post("/music/_search", query)
    {:ok, 200, %{aggregations: %{year_count: %{buckets: results}}}} = result

    results
    |> Enum.map(fn %{key: year, doc_count: count} -> %{year: year, count: count} end)
    |> Enum.sort_by(&Map.fetch(&1, :year))
  end

  def find_album_per_first_played_year_count do
    query = [
      size: 0,
      aggs: [
        first_played_year_count: [
          date_histogram: [
            field: "first_played",
            calendar_interval: "year",
            format: "yyyy",
            missing: "2005"
          ]
        ]
      ]
    ]

    {:ok, 200, %{aggregations: %{first_played_year_count: %{buckets: results}}}} = Tirexs.HTTP.post("/music/_search", query)

    IO.inspect(results)

    results
    |> Enum.map(fn %{key_as_string: year, doc_count: count} -> %{year: elem(Integer.parse(year), 0), count: count} end)
    |> Enum.sort_by(&Map.fetch(&1, :year))
  end

  def find_albums(search_string) do
    query = [
      index: "music",
      search: [
        from: 0,
        size: 50,
        query: [
          multi_match: [
            query: search_string,
            fields: ["artist", "title", "year.search"],
            lenient: true,
            type: "cross_fields",
            operator: "and"
          ]
        ]
      ]
    ]

    {:ok, 200, %{hits: %{hits: results}}} = Tirexs.Query.create_resource(query)
    ids = Enum.map(results, & &1._id)
    Repo.all(from a in Album, where: a.id in ^ids)
  end

  def get_album(id) do
    Repo.get(Album, id)
  end

  defp index_album(album) do
    with {:ok, album} <- album do
      payload =
        bulk(index: "music") do
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
    |> Album.changeset(attrs)
    |> Repo.insert()
    |> index_album
  end

  def update_album(id, attrs) do
    album =
      Album
      |> Repo.get(id)
      |> Repo.preload(sources: from(s in Source, order_by: s.id))

    case album do
      nil ->
        {:error, "Album not found"}

      album ->
        album
        |> Album.changeset(attrs)
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
          bulk(index: "music") do
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
end
