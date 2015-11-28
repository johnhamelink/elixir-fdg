defmodule FDG.ParserTest do
  use ExSpec, async: true
  doctest FDG.Parser

  it "Creates hash from label, and adds label to node" do
    ast = [{:node, [label: "Lorem Ipsum", children: []]}]
    dot_syntax = "digraph G { lorem_ipsum [label=\"Lorem Ipsum\"]; }"
    assert FDG.Parser.to_dot(ast) == dot_syntax
  end

  it "Parses Tuples into dot syntax recursively" do
    ast = [
      {:node, [label: "A", children: [
        {:node, [label: "B", children: []]},
        {:node, [label: "C", children: []]}
      ]]}
    ]

    dot_syntax = "digraph G { a [label=\"A\"]; b [label=\"B\"]; c [label=\"C\"]; a -> b; a -> c; }"
    assert FDG.Parser.to_dot(ast) == dot_syntax
  end

end
