defmodule FDG.Parsers.GraphvizTest do
  use ExSpec, async: true
  doctest FDG.Parsers.Graphviz

  setup do

    on_exit fn ->
      # Delete all the test files
      Enum.each(["png", "svg", "ps"], fn(fmt) ->
        File.rm "graph.#{fmt}"
      end)
    end

    :ok
  end


  @complex_ast [
    {:node, [label: "A", children: [
      {:node, [label: "B", children: []]},
      {:node, [label: "C", children: []]}
    ]]}
  ]

  it "Creates hash from label, and adds label to node" do
    ast = [{:node, [label: "Lorem Ipsum", children: []]}]
    dot_syntax = "digraph G { lorem_ipsum [label=\"Lorem Ipsum\"]; }"
    assert FDG.Parsers.Graphviz.to_dot(ast) == dot_syntax
  end

  it "Parses Tuples into dot syntax recursively" do
    dot_syntax = "digraph G { a [label=\"A\"]; b [label=\"B\"]; c [label=\"C\"]; a -> b; a -> c; }"
    assert FDG.Parsers.Graphviz.to_dot(@complex_ast) == dot_syntax
  end

  it "Can produce SVG files using Graphviz's `dot` command" do
    assert {:ok, "graph.svg"} = FDG.Parsers.Graphviz.to_dot(@complex_ast)
                                |> FDG.Parsers.Graphviz.to_svg("graph")
    assert File.exists? "graph.svg"
  end

  it "Can produce PNG files using Graphviz's `dot` command" do
    assert {:ok, "graph.png"} = FDG.Parsers.Graphviz.to_dot(@complex_ast)
                                |> FDG.Parsers.Graphviz.to_png("graph")
    assert File.exists? "graph.png"
  end

end
