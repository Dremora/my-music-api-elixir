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
    data
    |> cast(params, [
      :accurate_rip,
      :comments,
      :mbid,
      :cue_issues,
      :discs,
      :download,
      :edition,
      :format,
      :location,
      :tag_issues
    ])
    |> validate_inclusion(:location, ~w(apple-music spotify google-music foobar2000))
    |> validate_required([:location])
    |> validate_inclusion(:format, ~w(TAK MIXED MPC FLAC MP3 APE OFT WMA))
    |> validate_inclusion(:discs, 1..100)
    |> validate_length(:accurate_rip, max: 255)
    |> validate_length(:comments, max: 255)
    |> validate_length(:cue_issues, max: 255)
    |> validate_length(:download, max: 1000)
    |> validate_length(:edition, max: 255)
    |> validate_length(:tag_issues, max: 255)
    |> validate_format(
      :mbid,
      ~r/\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\z/
    )
  end
end
