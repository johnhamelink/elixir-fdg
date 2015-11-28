defmodule FDG.Parser do
  @moduledoc ~S"""
  Parses FDG AST into Graphviz (.dot) syntax

  ## Examples

    iex> FDG.Parser.to_dot([{:node, [label: "A", children: []]}])
    "digraph G { a [label=\"A\"]; }"

  """

  @typedoc """
  Node tuple
  """
  @type node_tuple :: {:node, [label: String.t, children: [...]]}

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

end
