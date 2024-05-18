defmodule Tamnoon.MixProject do
  use Mix.Project

  def project do
    [
      app: :tamnoon,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      # Docs
      name: "Tamnoon",
      source_url: "https://github.com/omer-sm/tamnoon",
      docs: [
        main: "Tamnoon",
        logo: "assets/logo.png"
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

  defp description, do: "A simple, customizable framework for Websocket server
  implementations. Make Elixir power your favorite front-end framework effortlessly!"

  defp package do
    [
      license: "Apache-2.0",
      links: %{"GitHub" => "https://github.com/omer-sm/tamnoon"}
    ]
  end
end
