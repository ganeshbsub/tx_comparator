defmodule TxComparator.Mixfile do
  use Mix.Project

  def project do
    [app: :tx_comparator,
     version: "0.0.1",
     elixir: "~> 1.3",
     description: "A simple text comparator",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def package do
  [ name: :tx_comparator,
    files: ["lib", "mix.exs"],
    maintainers: ["Ganesh Balasubramanian"],
    licenses: ["MIT"],
    links: %{"Github" => "https://github.com/ganeshbsub/tx_comparator"},
  ]
  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end
end
