defmodule FDG.Parser do
  @moduledoc ~S"""
  Contains Typedocs and general functions for parsing and
  manipulating FDG nodes.
  """

  @typedoc """
  Node tuple used to describe individual nodes. It's children is
  a list of zero or more node_tuples.
  """
  @type node_tuple :: {:node, [label: String.t, children: [node_tuple]]}

  @doc ~S"""
  Create an identifier, using the `label` associated with a node.
  """
  @spec normalize_label(String.t) :: String.t
  def normalize_label(label) do
    Regex.replace(~r/[^a-zA-Z0-9]/, label, "_")
    |> String.downcase
  end
end
