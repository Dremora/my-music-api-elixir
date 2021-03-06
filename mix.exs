defmodule MyMusic.Mixfile do
  use Mix.Project

  def project do
    [
      app: :my_music,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MyMusic.Application, []},
      extra_applications: [:logger, :runtime_tools, :tirexs, :absinthe_plug]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.3"},
      {:phoenix_ecto, "~> 4.1.0"},
      {:postgrex, ">= 0.15.3"},
      {:ecto_sql, "~> 3.4.2"},
      {:plug_cowboy, "~> 2.3.0"},
      {:cors_plug, "~> 2.0.0"},
      {:jason, "~> 1.2.0"},
      {:credo, "~> 1.4.0", only: [:dev, :test]},
      {:absinthe, "~> 1.4.16"},
      {:absinthe_plug, "~> 1.4.7"},
      {:dataloader, "~> 1.0.7"},
      {:tirexs, "~> 0.8.15"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "elasticsearch.create"],
      "ecto.import": "run priv/repo/seeds.exs",
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "elasticsearch.create": "run priv/repo/elasticsearch/create.exs",
      "elasticsearch.drop": "run priv/repo/elasticsearch/drop.exs",
      "elasticsearch.populate": "run priv/repo/elasticsearch/populate.exs"
    ]
  end
end
