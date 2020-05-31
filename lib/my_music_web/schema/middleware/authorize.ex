defmodule MyMusicWeb.Schema.Middleware.Authorize do
  alias Absinthe.Resolution

  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    case resolution.context do
      %{logged_in: true} ->
        resolution

      _ ->
        resolution
        |> Resolution.put_result({:error, "unauthorized"})
    end
  end
end
