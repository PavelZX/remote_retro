defmodule RemoteRetro.Mixfile do
  use Mix.Project

  def project do
    [
      app: :remote_retro,
      version: app_version(),
      default_task: "defaults",
      elixir: "1.10.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      aliases: aliases(),
      deps: deps(),
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {RemoteRetro, []}, extra_applications: extra_applications(Mix.env())]
  end

  defp extra_applications(:test), do: extra_applications(:default) -- [:os_mon]
  defp extra_applications(_),     do: [:logger, :os_mon]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.3"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.1.0"},
      {:ecto_sql, "~> 3.4.5"},
      {:freedom_formatter, "~> 1.1", only: :dev},
      {:distillery, "~> 2.1.1", only: :prod},
      {:excoveralls, "~> 0.13.1", only: :test},
      {:postgrex, "~> 0.15.5"},
      {:phoenix_html, "~> 2.14.2"},
      {:phoenix_live_dashboard, "~> 0.2.7"},
      {:phoenix_live_reload, "~> 1.2.4", only: :dev},
      {:plug_cowboy, "~> 2.3"},
      {:plug, "~> 1.10.1"},
      {:mix_test_watch, "~> 1.0.2", [runtime: false, only: :dev]},
      {:mock, "~> 0.3.5", only: :test},
      {:oauth2, "~> 2.0"},
      {:gettext, "~> 0.18.1"},
      {:wallaby, "~> 0.26.2", [runtime: false, only: :test]},
      {:shorter_maps, "~> 2.0"},
      {:slender_channel, "~> 1.0"},
      {:libcluster, "~> 3.2"},
      {:bamboo, "~> 1.5"},
      {:honeybadger, "~> 0.14.1"},
      {:apex, "~>1.2.1", only: [:dev, :test]},
      {:timex, "~> 3.6"},
      {:telemetry_poller, "~> 0.5.1"},
      {:telemetry_metrics, "~> 0.5"},
      {:jason, "~> 1.2.1"},
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
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test --exclude feature_test"],
      e2e: ["end_to_end"],
      defaults: ["preflight", "phx.server"],
    ]
  end

  # ensure unique app version for deploys of master from CircleCI, as a different
  # version is required by distillery for hot-upgrade deploys
  defp app_version do
    if Mix.env() == :prod do
      sha = System.get_env("SOURCE_VERSION")
      truncated_sha = String.slice(sha, 0, 7)
      "1.0.1-" <> truncated_sha
    else
      "1.0.1"
    end
  end
end
