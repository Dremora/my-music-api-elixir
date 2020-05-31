defmodule MyMusicWeb.Context do
  @behaviour Plug
  import Plug.Conn
  import Absinthe.Plug

  alias MyMusicWeb.Authentication

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- Authentication.verify(token) do
      %{logged_in: true}
    else
      _ -> %{}
    end
  end
end
