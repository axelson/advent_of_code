defmodule Day6.MixProject do
  use Mix.Project

  def project do
    [
      app: :day6,
      version: "0.1.0",
      elixir: "~> 1.7",
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
      {:exsync, git: "git@github.com:axelson/exsync.git", only: :dev}
    ]
  end
end
