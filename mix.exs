defmodule Tamnoon.MixProject do
  use Mix.Project

  def project do
    [
      app: :tamnoon,
      version: "1.0.0-a.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      # Docs
      name: "Tamnoon",
      source_url: "https://github.com/omer-sm/tamnoon",
      docs: [
        main: "readme",
        logo: "assets/logo.png",
        extras: ["README.md", "changelog.md", "guides/getting started.md", "guides/basic usage.md",
                "guides/custom methods.md", "guides/pubsub.md",
                "guides/troubleshooting.md", "guides/method overview.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.12"},
      {:plug, "~> 1.15"},
      {:plug_cowboy, "~> 2.7"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.32.2", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/omer-sm/tamnoon"}
    ]
  end

  defp description, do: "A simple, customizable framework for Websocket server
  implementations. Make Elixir power your favorite front-end framework effortlessly!"

end
