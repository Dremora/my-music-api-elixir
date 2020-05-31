defmodule MyMusicWeb.Resolvers.Account do
  alias MyMusicWeb.Authentication

  def login(%{password: password}, _) do
    {:ok, Authentication.verify(password)}
  end
end
