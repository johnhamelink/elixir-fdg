defmodule FDG.Parser do

  @typedoc """
  Node tuple used to describe individual nodes. It's children is
  a list of zero or more node_tuples.
  """
  @type node_tuple :: {:node, [label: String.t, children: [node_tuple]]}
end
