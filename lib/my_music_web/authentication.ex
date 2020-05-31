defmodule MyMusicWeb.Authentication do
  alias MyMusicWeb.Endpoint

  def verify(password) do
    password === Endpoint.config(:user_password)
  end
end
