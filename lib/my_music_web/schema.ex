defmodule MyMusicWeb.Schema do
  use Absinthe.Schema

  alias Absinthe.Middleware.Dataloader, as: DataloaderMiddleware
  alias Absinthe.Plugin
  alias MyMusicWeb.Resolvers
  alias MyMusicWeb.Resolvers.Account
  alias MyMusicWeb.Schema.Middleware

  def plugins do
    [DataloaderMiddleware | Plugin.defaults()]
  end

  def dataloader do
    alias MyMusic.Library

    Dataloader.new()
    |> Dataloader.add_source(Library, Library.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  import_types MyMusicWeb.Schema.Types

  query do
    field :albums, non_null(list_of(non_null(:album))) do
      arg :query, non_null(:string)

      resolve &Resolvers.Library.find_albums/3
    end

    field :album, non_null(:album) do
      arg :id, non_null(:binary_id)

      resolve &Resolvers.Library.get_album/3
    end

    field :album_per_year_count,
          non_null(list_of(non_null(:album_per_year_count))) do
      resolve &Resolvers.Library.find_album_per_year_count/3
    end

    field :album_per_first_played_year_count,
          non_null(list_of(non_null(:album_per_year_count))) do
      resolve &Resolvers.Library.find_album_per_first_played_year_count/3
    end
  end

  mutation do
    field :login, type: non_null(:boolean) do
      arg :password, non_null(:string)

      resolve &Account.login/2
    end

    field :create_album, type: non_null(:album) do
      arg :title, non_null(:string)
      arg :artist, non_null(:string)
      arg :comments, :string
      arg :year, :integer
      arg :first_played, :first_played_input
      arg :sources, non_null(list_of(non_null(:new_source_input)))

      middleware Middleware.Authorize
      resolve &MyMusicWeb.Resolvers.Library.create_album/2
    end

    field :update_album, type: non_null(:album) do
      arg :id, non_null(:binary_id)
      arg :title, non_null(:string)
      arg :artist, non_null(:string)
      arg :comments, :string
      arg :year, :integer
      arg :first_played, :first_played_input
      arg :sources, non_null(list_of(non_null(:source_input)))

      middleware Middleware.Authorize
      resolve &MyMusicWeb.Resolvers.Library.update_album/2
    end

    field :delete_album, type: :album do
      arg :id, non_null(:binary_id)

      middleware Middleware.Authorize
      resolve &MyMusicWeb.Resolvers.Library.delete_album/2
    end
  end
end
