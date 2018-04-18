defmodule MyMusicWeb.Schema do
  use Absinthe.Schema

  alias MyMusicWeb.Resolvers
  alias MyMusicWeb.Schema.Middleware

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader() do
    alias MyMusic.Library

    Dataloader.new()
    |> Dataloader.add_source(Library, Library.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  import_types MyMusicWeb.Schema.Types

  query do
    field :albums, list_of(non_null(:album)) do
      arg :query, non_null(:string)

      resolve &Resolvers.Library.find_albums/3
    end

    field :album, :album do
      arg :id, non_null(:binary_id)

      resolve &Resolvers.Library.get_album/3
    end
  end

  mutation do
    field :login, type: :boolean do
      arg :password, non_null(:string)

      resolve &MyMusicWeb.Resolvers.Account.login/2
    end

    field :create_album, type: :album do
      arg :title, non_null(:string)
      arg :artist, non_null(:string)
      arg :comments, :string
      arg :year, :integer
      arg :first_played, :first_played_time
      arg :sources, non_null(list_of(non_null(:new_source_input)))

      middleware Middleware.Authorize
      resolve &MyMusicWeb.Resolvers.Library.create_album/2
    end

    field :update_album, type: :album do
      arg :id, non_null(:binary_id)
      arg :title, non_null(:string)
      arg :artist, non_null(:string)
      arg :comments, :string
      arg :year, :integer
      arg :first_played, :first_played_time
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
