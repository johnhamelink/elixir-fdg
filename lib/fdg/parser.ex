defmodule FDG.Parser do

  @typedoc """
  Node tuple used to describe individual nodes. It's children is
  a list of zero or more node_tuples.
  """
  @type node_tuple :: {:node, [label: String.t, children: [node_tuple]]}

  @spec normalize_label(String.t) :: String.t
  def normalize_label(label) do
    Regex.replace(~r/[^a-zA-Z0-9]/, label, "_")
    |> String.downcase
  end
end
