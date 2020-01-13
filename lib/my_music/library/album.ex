defmodule MyMusic.Library.Album do
  use Ecto.Schema
  import Ecto.Changeset
  import MyMusic.Helpers
  alias MyMusic.Library.Album
  alias MyMusic.Library.Source

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "albums" do
    field :artist, :string
    field :comments, :string
    field :first_played_date, {:array, :integer}
    field :first_played_timestamp, :utc_datetime
    field :title, :string
    field :year, :integer
    has_many :sources, Source, on_replace: :delete

    timestamps()
  end

  def changeset(%Album{} = album, attrs) do
    changes =
      album
      |> cast(attrs, [:artist, :title, :year, :comments])
      |> cast_assoc(:sources)
      |> trim_fields([:artist, :title, :comments])
      |> validate_required([:artist, :title])
      |> validate_length(:artist, max: 255)
      |> validate_length(:title, max: 255)
      |> validate_length(:comments, max: 255)
      |> validate_inclusion(:year, 1900..2100)

    cond do
      Map.has_key?(attrs, :first_played) ->
        cond do
          is_map(attrs.first_played) && Map.has_key?(attrs.first_played, :year) ->
            date = [
              Map.get(attrs.first_played, :year),
              Map.get(attrs.first_played, :month),
              Map.get(attrs.first_played, :day)
            ]

            changes
            |> put_change(:first_played_timestamp, nil)
            |> cast(%{first_played_date: date}, [:first_played_date])
            |> validate_length(:first_played_date, min: 1, max: 3)

          is_map(attrs.first_played) && Map.has_key?(attrs.first_played, :timestamp) ->
            date = DateTime.from_unix!(attrs.first_played.timestamp)

            changes
            |> put_change(:first_played_date, nil)
            |> cast(%{first_played_timestamp: date}, [:first_played_timestamp])

          is_nil(attrs.first_played) ->
            changes
            |> put_change(:first_played_date, nil)
            |> put_change(:first_played_timestamp, nil)

          true ->
            add_error(changes, :first_played, "is invalid")
        end

      Map.has_key?(attrs, "first_played") ->
        # JSON import only
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

          is_nil(attrs["first_played"]) ->
            changes
            |> put_change(:first_played_date, nil)
            |> put_change(:first_played_timestamp, nil)

          true ->
            add_error(changes, :first_played, "is invalid")
        end

      true ->
        changes
    end
  end
end
