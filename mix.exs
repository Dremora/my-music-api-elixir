defmodule MyMusic.Mixfile do
  use Mix.Project

  def project do
    [app: :my_music,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {MyMusic.Application, []},
     extra_applications: [:logger, :runtime_tools, :tirexs]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0-rc"},
     {:phoenix_ecto, "~> 3.2"},
     {:postgrex, ">= 0.0.0"},
     {:cowboy, "~> 1.0"},
     {:credo, "~> 0.5", only: [:dev, :test]},
     {:tirexs, "~> 0.8"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "elasticsearch.create", "elasticsearch.populate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "elasticsearch.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"],
     "json-to-postgres": "run priv/repo/json-to-postgres.exs",
     "elasticsearch.create": "run priv/repo/elasticsearch/create.exs",
     "elasticsearch.drop": "run priv/repo/elasticsearch/drop.exs",
     "elasticsearch.populate": "run priv/repo/elasticsearch/populate.exs"]
  end
end
