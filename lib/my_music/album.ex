defmodule MyMusic.Album do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "albums" do
    field :artist, :string
    field :comments, :string
    field :first_played_date, {:array, :integer}
    field :first_played_timestamp, :utc_datetime
    field :title, :string
    field :year, :integer
    has_many :sources, MyMusic.Source

    timestamps()
  end

  def changeset(data, params) do
    changes = data
    |> cast(params, [:artist, :title, :year, :comments])
    |> cast_assoc(:sources)

    if Map.has_key?(params, "first_played") do
      cond do
        is_list(params["first_played"]) ->
          cast(changes, %{first_played_date: params["first_played"]},
            [:first_played_date])
        is_integer(params["first_played"]) ->
          date = DateTime.from_unix!(params["first_played"], :millisecond)
          cast(changes, %{first_played_timestamp: date},
            [:first_played_timestamp])
        true ->
          changes
      end
    else
      changes
    end
  end
end
