defmodule Sum.Mixfile do
  use Mix.Project

  @version "0.5.0"
  def project do
    [
      app: :sum,
      elixir: "~> 1.5",
      version: @version,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [extras: ["README.md"]],
      package: [
        maintainers: ["Louis Pilfold"],
        licenses: ["apache-2.0"],
        links: %{"GitHub" => "https://github.com/lpil/sum"},
        files: ~w(LICENCE README.md lib mix.exs)
      ]
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      # Automatic test runner
      {:mix_test_watch, "~> 0.4", [only: :dev, runtime: false]},
      # Markdown processor
      {:earmark, "~> 1.2", [only: :dev, runtime: false]},
      # Documentation generator
      {:ex_doc, "~> 0.15", [only: :dev, runtime: false]}
    ]
  end
end
