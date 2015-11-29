defmodule FDG.Parser do
  @moduledoc ~S"""
  Parses FDG AST into Graphviz (.dot) syntax, and allows
  for exporting to Various image formats using Graphviz.

  ## Examples

      iex> FDG.Parser.to_dot([{:node, [label: "A", children: []]}])
      "digraph G { a [label=\"A\"]; }"

  """

  @typedoc """
  Node tuple used to describe individual nodes. It's children is
  a list of zero or more node_tuples.
  """
  @type node_tuple :: {:node, [label: String.t, children: [node_tuple]]}

  @doc ~S"""
  Turns FDG `dot_syntax` string into a PNG digraph, using `Graphviz's`
  `dot` command. Returns the filename of the output file `output_filename`.

  ## Examples

      iex> FDG.Parser.to_dot([{:node, [label: "A", children: []]}])
      ...> |> FDG.Parser.to_png("graph")
      {:ok, "graph.png"}

  """
  @spec to_png(String.t, String.t) :: {atom(), String.t}
  def to_png(dot_syntax, output_filename) do
    dot_syntax
    |> to_graphviz("png", output_filename)
  end

  @doc ~S"""
  Turns FDG `dot_syntax` string into an SVG digraph, using `Graphviz's`
  `dot` command. Returns the filename of the output file `output_filename`.

  ## Examples

      iex> FDG.Parser.to_dot([{:node, [label: "A", children: []]}])
      ...> |> FDG.Parser.to_svg("graph")
      {:ok, "graph.svg"}

  """
  @spec to_svg(String.t, String.t) :: {atom(), String.t}
  def to_svg(dot_syntax, output_filename) do
    dot_syntax
    |> to_graphviz("svg", output_filename)
  end

  @doc ~S"""
  Turns dot syntax into something else using Graphviz. The `format`
  attribute can accept anything that Graphviz can. A non-exhausted
  list being:

    - `ps` (PostScript)
    - `svg` and `svgz` (Structured Vector Graphics)
    - `fig` (XFIG Graphics)
    - `png` and `gif` (Bitmap Graphics)
    - `imap` and `cmapx`

  ## Examples

      iex> FDG.Parser.to_dot([{:node, [label: "A", children: []]}])
      ...> |> FDG.Parser.to_graphviz("ps", "graph")
      {:ok, "graph.ps"}

  """
  def to_graphviz(dot_syntax, format, output_filename) do
    {:ok, tmp_file} = create_tmp_file(dot_syntax)
    run_dot(tmp_file, output_filename, format)
    delete_tmp_file(tmp_file)
    {:ok, "#{output_filename}.#{format}"}
  end


  @doc ~S"""
  Turns FDG `ast` tuples into a dot-syntax string, ready to
  be parsed into a graph using Graphviz.

  ## Examples

      iex> FDG.Parser.to_dot([{:node, [label: "A", children: []]}])
      "digraph G { a [label=\"A\"]; }"

  """
  @spec to_dot([node_tuple]) :: String.t
  def to_dot(ast) do
    connections = parse_dot(ast)
    Regex.replace(~r/[ ]+/, "digraph G { #{connections} }", " ")
  end

  @spec parse_dot([node_tuple]) :: String.t
  defp parse_dot([{:node, [label: label, children: children]}]) when is_list(children) do
    id = normalize_label(label)
    [
      define_node(label),
      parse_dot(children),
      parse_children_associations(id, children)
    ] |> Enum.join(" ")
  end

  @spec parse_dot([node_tuple]) :: String.t
  defp parse_dot([{:node, [label: label, children: children]} | tail]) when is_list(children) and is_list(tail) do
    id = normalize_label(label)
    [
      define_node(label),
      parse_dot(tail),
      parse_children_associations(id, children)
    ] |> Enum.join(" ")
  end

  @spec parse_dot([]) :: []
  defp parse_dot([]), do: []

  @spec define_node(String.t) :: String.t
  defp define_node(label) do
    atts = ["label=\"#{label}\""]
    [
      normalize_label(label),
      "[#{Enum.join(atts, ", ")}];"
    ] |> Enum.join(" ")
  end

  @spec normalize_label(String.t) :: String.t
  defp normalize_label(label) do
    Regex.replace(~r/[^a-zA-Z]/, label, "_")
    |> String.downcase
  end

  @spec parse_children_associations(String.t, [node_tuple]) :: String.t
  defp parse_children_associations(label, children) do
    Enum.reduce(children, "", fn ({:node, [label: child_label, children: _]}, acc) ->
      [
        acc,
        normalize_label(label),
        "->",
        "#{normalize_label(child_label)};"
      ] |> Enum.join(" ")
    end)
  end

  @spec create_tmp_file(String.t) :: {:ok, String.t}
  defp create_tmp_file(dot_syntax) do
    tmp_file = "tmp.#{:os.system_time(:seconds)}.dot"
    {:ok, file} = File.open tmp_file, [:write]
    :ok = IO.binwrite file, dot_syntax
    :ok = File.close file
    {:ok, tmp_file}
  end

  @spec run_dot(String.t, String.t, String.t) :: {Collectable.t, exit_status :: non_neg_integer}
  defp run_dot(input_file, output_filename, format) do
    System.cmd("dot", ["-T#{format}", "-o#{output_filename}.#{format}", input_file])
  end

  @spec delete_tmp_file(String.t) :: :ok
  defp delete_tmp_file(tmp_file), do: File.rm(tmp_file)

end
