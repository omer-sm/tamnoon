defmodule Tamnoon.MixProject do
  use Mix.Project

  def project do
    [
      app: :tamnoon,
      version: "1.0.0-a.5",
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
        assets: "assets",
        groups_for_modules: [
          "DOM": ~r/^Tamnoon\.DOM(?!\.Actions(\.|$))/,
          "DOM Actions": ~r/^Tamnoon\.DOM\.Actions.*/
        ],
        extras: ["README.md", "changelog.md", "guides (new)/overview.md",
        "guides (new)/getting started.md", "guides (new)/components.md",
        "guides (new)/the state and methods.md", "guides (new)/tamnoon heex.md",
        "guides (new)/wrapping up.md", "guides (new)/deployment.md"]
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

  defp description, do: "A simplicity-first web framework for Elixir, designed to make building web applications easy and enjoyable."

end
