defmodule Tamnoon.DOM.NodeCollection do
  @moduledoc """
  Represents a DOM node collection. Accepts two parameters for how to select the nodes,
  `:selector_type` and `:selector_value`. For example, when `:selector_type` is `:children` and
  `:selector_value` is a `t:Tamnoon.DOM.Node.t/0`, it will be equivalent to using
  `element.children()` in JS.


  ## Fields

    * `:selector_type` – an atom indicating the type of selector.
      - Expected values: `:xpath_collection`, `:children`.

    * `:selector_value` – the value associated with the selector.
      - `:children`: a `t:Tamnoon.DOM.Node.t/0` of the parent node.
      - `:xpath_collection`: a `t:String.t/0` of the xpath to select.
  """

  alias Tamnoon.DOM
  import DOM

  @derive Jason.Encoder
  @enforce_keys [:selector_type, :selector_value]
  defstruct [:selector_type, :selector_value]

  @type t :: %__MODULE__{
          selector_type: :xpath_collection | :children,
          selector_value: String.t() | Tamnoon.DOM.Node.t()
        }

  @spec is_node_collection?(node_collection :: any()) :: boolean()
  def is_node_collection?(node_collection)

  def is_node_collection?(%DOM.NodeCollection{}), do: true

  def is_node_collection?(%{selector_type: :children, selector_value: %DOM.Node{}}), do: true

  def is_node_collection?(%{selector_type: :xpath_collection, selector_value: value})
    when is_binary(value), do: true

  def is_node_collection?(_), do: false


  def new!(%DOM.NodeCollection{} = node_collection), do: node_collection

  def new!(node_collection) do
    validate_type!(node_collection, &is_node_collection?/1, DOM.NodeCollection)

    struct!(DOM.NodeCollection, node_collection)
  end
end
