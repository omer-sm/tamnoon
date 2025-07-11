defmodule Tamnoon.DOM.Node do
  @moduledoc """
  Represents a DOM node. Accepts two parameters for how to select the node,
  `:selector_type` and `:selector_value`. For example, when `:selector_type` is `:id` and
  `:selector_value` is `"id-to-select"`, it will be equivalent to using
  `document.getElementById("id-to-select")` in JS.


  ## Fields

    * `:selector_type` – an atom indicating the type of selector.
      - Expected values: `:id`, `:xpath`, `:from_string`, `:first_element`, `:last_element`.

    * `:selector_value` – the value associated with the selector.
      - `:id`: a `t:String.t/0` of the id to select.
      - `:xpath`: a `t:String.t/0` of the node's xpath.
      - `:from_string`: a `t:String.t/0` representing the HTML element.
      - `:first_element` and `:last_element`: a `t:Tamnoon.DOM.NodeCollection.t/0` representing the collection to query.
  """

  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :node

  @enforce_keys [:selector_type, :selector_value]
  defstruct [:selector_type, :selector_value]

  @placeholder_selector_types [:iteration_placeholder]
  @single_selector_types [:id, :xpath, :from_string]
  @collection_selector_types [:first_element, :last_element]

  @type t :: %__MODULE__{
          selector_type: :id | :xpath | :from_string | :first_element | :last_element | :iteration_placeholder,
          selector_value: String.t() | DOM.NodeCollection.t() | nil
        }

  @spec is_node?(node :: any()) :: boolean()
  def is_node?(node)

  def is_node?(%DOM.Node{}), do: true

  def is_node?(%{selector_type: type, selector_value: value})
      when type in @placeholder_selector_types and is_nil(value),
      do: true

  def is_node?(%{selector_type: type, selector_value: value})
      when type in @single_selector_types and is_binary(value),
      do: true

  def is_node?(%{selector_type: type, selector_value: value})
      when type in @collection_selector_types and is_struct(value, DOM.NodeCollection),
      do: true

  def is_node?(_), do: false

  @spec new!(node :: term()) :: %DOM.Node{}
  def new!(%DOM.Node{} = node), do: node

  def new!(node) do
    validate_type!(node, &is_node?/1, DOM.Node)

    struct(DOM.Node, node)
  end
end
