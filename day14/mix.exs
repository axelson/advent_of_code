defmodule Day14.MixProject do
  use Mix.Project

  def project do
    [
      app: :day14,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:advent, path: "../advent"},
      {:exsync, path: "~/dev/forks/exsync", only: :dev},
      {:nimble_parsec, "~> 0.2"}
    ]
  end
end
