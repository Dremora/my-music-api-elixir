defmodule MyMusic.Album do
  use Ecto.Schema

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
end
