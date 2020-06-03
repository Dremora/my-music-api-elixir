defmodule MyMusic.Library do
  import Ecto.{Query, Changeset}, warn: false
  import Tirexs.Bulk

  alias Dataloader.Ecto
  alias MyMusic.Library.Album
  alias MyMusic.Library.Source
  alias MyMusic.Repo
  alias Tirexs.HTTP
  alias Tirexs.Query

  def data do
    Ecto.new(Repo, query: &query/2)
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

    result = HTTP.post("/music/_search", query)
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

    {
      :ok,
      200,
      %{aggregations: %{first_played_year_count: %{buckets: results}}}
    } = HTTP.post("/music/_search", query)

    results
    |> Enum.map(fn %{key_as_string: year, doc_count: count} ->
      %{year: elem(Integer.parse(year), 0), count: count}
    end)
    |> Enum.sort_by(&Map.fetch(&1, :year))
  end

  def find_albums(%{query: query}) do
    query = [
      index: "music",
      search: [
        from: 0,
        size: 50,
        query: [
          multi_match: [
            query: query,
            fields: ["artist", "title", "year.search"],
            lenient: true,
            type: "cross_fields",
            operator: "and"
          ]
        ]
      ]
    ]

    {
      :ok,
      200,
      %{hits: %{hits: results}}
    } = Query.create_resource(query)

    ids = Enum.map(results, & &1._id)
    get_albums_by_ids(ids)
  end

  def get_albums_by_ids(ids) do
    Repo.all(from a in Album, where: a.id in ^ids)
  end

  def get_album(id) do
    Repo.get(Album, id)
  end

  def index_first_played(album) do
    case {album.first_played_date, album.first_played_timestamp} do
      {[year, nil, nil], nil} -> "#{year}"
      {[year, month, nil], nil} -> "#{year}-#{month}"
      {[year, month, day], nil} -> "#{year}-#{month}-#{day}"
      {nil, %DateTime{} = timestamp} -> DateTime.to_unix(timestamp)
      {nil, nil} -> nil
      x -> raise "Unrecognized firstPlayed format: " <> inspect(x)
    end
  end

  def to_elasticsearch(album) do
    [
      id: album.id,
      artist: album.artist,
      title: album.title,
      year: album.year,
      first_played: index_first_played(album)
    ]
  end

  defp index_album(album) do
    with {:ok, album} <- album do
      payload =
        bulk(index: "music") do
          index([
            to_elasticsearch(album)
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
