defmodule MyMusicWeb.Schema.Types do
  use Absinthe.Schema.Notation
  alias MyMusicWeb.Resolvers

  object :album do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :artist, non_null(:string)
    field :comments, :string
    field :year, :integer
    field :first_played, :first_played_time do
      resolve fn album, _args, _info ->
        cond do
          album.first_played_timestamp ->
            {:ok , DateTime.to_unix(album.first_played_timestamp, :millisecond)}
          album.first_played_date -> {:ok , album.first_played_date}
          true -> {:ok , nil}
        end
      end
    end
    field :sources, non_null(list_of(:source)) do
      resolve &Resolvers.Source.byAlbum/3
    end
  end

  object :source do
    field :id, non_null(:id)
    field :accurate_rip, :string
    field :comments, :string
    field :cue_issues, :string
    field :discs, :integer
    field :download, :string
    field :edition, :string
    field :format, :format
    field :location, non_null(:location)
    field :mbid, :string
    field :tag_issues, :string
  end

  scalar :first_played_time do
    parse fn(value) ->
      value
    end

    serialize fn(value) ->
      value
    end
  end

  enum :location do
    value :foobar2000, as: "foobar2000"
    value :google_music, as: "google-music"
    value :spotify, as: "spotify"
    value :apple_music, as: "apple-music"
  end

  enum :format do
    value :tak, as: "TAK"
    value :mixed, as: "Mixed"
    value :mpc, as: "MPC"
    value :flac, as: "FLAC"
    value :mp3, as: "MP3"
    value :ape, as: "APE"
  end

  input_object :source_input do
    field :accurate_rip, :string
    field :comments, :string
    field :cue_issues, :string
    field :discs, :integer
    field :download, :string
    field :edition, :string
    field :format, :string
    field :location, non_null(:location)
    field :mbid, :string
    field :tag_issues, :string
  end
end