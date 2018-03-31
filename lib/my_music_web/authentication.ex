defmodule MyMusicWeb.Authentication do
  def verify(password) do
    password === MyMusicWeb.Endpoint.config(:user_password)
  end
end
