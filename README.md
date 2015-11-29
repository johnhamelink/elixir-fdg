# FDG

---

[![Hex Version](https://img.shields.io/hexpm/v/fdg.svg)](https://hex.pm/packages/fdg) [![Build Status](https://travis-ci.org/johnhamelink/elixir-fdg.svg?branch=master)](https://travis-ci.org/johnhamelink/elixir-fdg)  [![Inline docs](http://inch-ci.org/github/johnhamelink/elixir-fdg.svg)](http://inch-ci.org/github/johnhamelink/elixir-fdg) [![HexDocs](https://img.shields.io/badge/Hex-Docs-blue.svg)](https://hexdocs.pm/fdg)

---

## This project is not yet complete, nor is it ready to be used. If you fancy helping making it complete, be my guest!

FDG is a simple library for producing Force directed graphs. FDG aims to allow you to build a simple tree of relations into a graph that can then be exported in multiple different formats for further analysis.

### FDG plans to support:

#### Importing from:
 - [ ] [Erlang's Digraph module](http://www.erlang.org/doc/man/digraph.html)
 - [ ] `dot` syntax for [Graphviz](http://www.graphviz.org)
 - [ ] [GraphML](http://graphml.graphdrawing.org)
 - [ ] [Cypher query language](http://neo4j.com/docs/stable/cypher-query-lang.html) - specifically Neo4j database dumps

#### Exporting to:

 - [x] `dot` syntax for [Graphviz](http://www.graphviz.org), and all the image formats it supports as a result.
 - [x] [GraphML](http://graphml.graphdrawing.org) for use with exporting to tools such as [Gephi](https://gephi.github.io)
 - [ ] [Cypher query language](http://neo4j.com/docs/stable/cypher-query-lang.html) for importing into supported Graph databases, such as [Neo4j](neo4j.com)

## Installation

The package can be installed as:

  1. Add fdg to your list of dependencies in `mix.exs`:

        def deps do
          [{:fdg, "~> 0.0.2"}]
        end

  2. Ensure fdg is started before your application:

        def application do
          [applications: [:fdg]]
        end

## Configuration

### Graphviz

If you wish to use the Graphviz parser, make sure you have Graphviz installed and in your [PATH](https://en.wikipedia.org/wiki/PATH_(variable)). The Graphviz parser uses the `dot` command to produce its images.

## Getting Started

##### TODO - please refer to the [Hexdocs](https://hexdocs.pm/fdg) for now.

## Further Documentation

Up to date documentation is available on [Hexdocs](https://hexdocs.pm/fdg) - check there for detailed documentation of all functionality.
