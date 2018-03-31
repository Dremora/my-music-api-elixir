defmodule MyMusicWeb.Context do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- MyMusicWeb.Authentication.verify(token) do
      %{logged_in: true}
    else
      _ -> %{}
    end
  end
end
