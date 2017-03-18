defmodule MyMusic.Library.Source do
  use Ecto.Schema
  import Ecto.Changeset

  schema "album_sources" do
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

  def changeset(data, params) do
    changes = data
    |> cast(params, [:accurate_rip, :comments,
      :cue_issues, :discs, :download, :edition, :format, :location, :tag_issues
    ])
    |> validate_inclusion(:location, ~w(apple-music spotify google-music foobar2000))
    |> validate_length(:download, max: 1000)

    if is_binary(params["mbid"]) do
      cast(changes, %{mbid: params["mbid"]}, [:mbid])
    else
      changes
    end
  end
end
