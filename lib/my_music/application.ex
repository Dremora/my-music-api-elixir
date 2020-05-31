defmodule MyMusic.Application do
  use Application
  alias MyMusicWeb.Endpoint

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(MyMusic.Repo, []),
      # Start the PubSub system
      {Phoenix.PubSub, name: MyMusicWeb.PubSub},
      # Start the endpoint when the application starts
      supervisor(Endpoint, [])
    ]

    # See http://hexdocs.pm/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyMusic.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
