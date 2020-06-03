defmodule MyMusicWeb.Schema.Types do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias MyMusic.Library
  alias MyMusicWeb.Schema.Middleware

  object :album_per_year_count do
    field :year, non_null(:integer)
    field :count, non_null(:integer)
  end

  object :album do
    field :id, non_null(:binary_id)
    field :title, non_null(:string)
    field :artist, non_null(:string)
    field :comments, :string
    field :year, :integer

    field :first_played, :first_played do
      resolve fn album, _args, _info ->
        cond do
          album.first_played_timestamp ->
            {:ok, %{timestamp: DateTime.to_unix(album.first_played_timestamp)}}

          album.first_played_date ->
            {:ok,
             %{
               year: Enum.at(album.first_played_date, 0),
               month: Enum.at(album.first_played_date, 1),
               day: Enum.at(album.first_played_date, 2)
             }}

          true ->
            {:ok, nil}
        end
      end
    end

    field :sources, non_null(list_of(non_null(:source))) do
      resolve dataloader(Library)
    end
  end

  object :source do
    field :id, non_null(:id)
    field :accurate_rip, :string
    field :comments, :string
    field :cue_issues, :string
    field :discs, :integer

    field :download, :string do
      middleware Middleware.Authorize
      middleware Absinthe.Middleware.MapGet, :download
    end

    field :edition, :string
    field :format, :format
    field :location, non_null(:location)
    field :mbid, :binary_id
    field :tag_issues, :string
  end

  object :first_played_date do
    field :year, non_null(:integer)
    field :month, :integer
    field :day, :integer
  end

  object :first_played_time do
    field :timestamp, non_null(:integer)
  end

  union :first_played do
    types [:first_played_date, :first_played_time]

    resolve_type fn
      %{timestamp: _}, _ -> :first_played_time
      _, _ -> :first_played_date
    end
  end

  input_object :album_filter_input do
    field :query, :string
  end

  input_object :first_played_input do
    field :year, :integer
    field :month, :integer
    field :day, :integer
    field :timestamp, :integer
  end

  enum :location do
    value :foobar2000, as: "foobar2000"
    value :google_music, as: "google-music"
    value :spotify, as: "spotify"
    value :apple_music, as: "apple-music"
  end

  enum :format do
    value :tak, as: "TAK"
    value :mixed, as: "MIXED"
    value :mpc, as: "MPC"
    value :flac, as: "FLAC"
    value :mp3, as: "MP3"
    value :ape, as: "APE"
    value :oft, as: "OFT"
    value :wma, as: "WMA"
  end

  input_object :new_source_input do
    field :accurate_rip, :string
    field :comments, :string
    field :cue_issues, :string
    field :discs, :integer
    field :download, :string
    field :edition, :string
    field :format, :string
    field :location, non_null(:location)
    field :mbid, :binary_id
    field :tag_issues, :string
  end

  input_object :source_input do
    field :id, :id
    field :accurate_rip, :string
    field :comments, :string
    field :cue_issues, :string
    field :discs, :integer
    field :download, :string
    field :edition, :string
    field :format, :string
    field :location, non_null(:location)
    field :mbid, :binary_id
    field :tag_issues, :string
  end

  scalar :binary_id do
    serialize & &1

    parse fn value ->
      r = ~r/\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\z/

      case value do
        %Absinthe.Blueprint.Input.Null{} ->
          {:ok, nil}

        %Absinthe.Blueprint.Input.String{value: value} ->
          if String.match?(value, r) do
            {:ok, value}
          else
            :error
          end

        _ ->
          :error
      end
    end
  end
end
