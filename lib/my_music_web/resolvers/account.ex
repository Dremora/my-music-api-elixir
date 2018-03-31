defmodule MyMusicWeb.Resolvers.Account do
  def login(%{password: password}, _) do
    {:ok, MyMusicWeb.Authentication.verify(password)}
  end
end
