defmodule MyMusic.Source do
  use Ecto.Schema

  schema "sources" do
    field :accurate_rip, :string
    field :comments, :string
    field :cue_issues, :string
    field :discs, :integer
    field :download, :string
    field :edition, :string
    field :format, :string
    field :location, :string
    field :mbid, :binary_id
    field :tag_issues, :string
    field :album_id, :binary_id

    timestamps()
  end
end
