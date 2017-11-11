defmodule MyMusicWeb.Schema do
  use Absinthe.Schema

  alias MyMusicWeb.Resolvers

  import_types MyMusicWeb.Schema.Types

  query do
    field :albums, list_of(:album) do
      arg :query, non_null(:string)

      resolve &Resolvers.Album.find/3
    end

    field :album, :album do
      arg :id, non_null(:binary_id)

      resolve &Resolvers.Album.find_one/3
    end

  end

  mutation do
    field :create_album, type: :album do
      arg :title, non_null(:string)
      arg :artist, non_null(:string)
      arg :comments, :string
      arg :year, :integer
      arg :first_played, :first_played_time
      arg :sources, non_null(list_of(:source_input))

      resolve &MyMusicWeb.Resolvers.Album.create/2
    end

    field :update_album, type: :album do
      arg :id, non_null(:binary_id)
      arg :title, non_null(:string)
      arg :artist, non_null(:string)
      arg :comments, :string
      arg :year, :integer
      arg :first_played, :first_played_time
      arg :sources, non_null(list_of(:source_input))

      resolve &MyMusicWeb.Resolvers.Album.update/2
    end

    field :delete_album, type: :album do
      arg :id, non_null(:binary_id)

      resolve &MyMusicWeb.Resolvers.Album.delete/2
    end
  end
end
