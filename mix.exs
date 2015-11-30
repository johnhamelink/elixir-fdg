defmodule FDG.Mixfile do
  use Mix.Project

  def project do
    [app: :fdg,
     version: "0.0.4",
     elixir: "~> 1.1",
     name: "FDG",
     source_url: "https://github.com/johnhamelink/elixir-fdg",
     homepage: "https://github.com/johnhamelink/elixir-fdg",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps,
     docs: [extras: ["README.md"]],
     dialyzer: []
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: []]
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
    [
      {:xml_builder, github: "joshnuss/xml_builder", branch: "master"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:ex_spec, "~> 1.0.0", only: :test},
      {:inch_ex, only: :docs},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:neo4j, github: "dmitriid/neo4j-erlang", only: :test},
      {:jiffy, github: "davisp/jiffy", only: :test},
      {:exjsx, "~> 3.2", only: :test},
    ]
  end

  defp description do
    """
    This project aims to be a simple library with which to build force directed
    graphs. Ideally, FDG will be used to produce visualiations of networks and
    static analysis of code.
    """
  end

  defp package do
    [
      maintainers: ["John Hamelink"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/johnhamelink/elixir-fdg",
        "Docs" => "http://hexdocs.pm/fdg"
      }
    ]
  end

end
