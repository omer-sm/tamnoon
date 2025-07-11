defmodule Tamnoon.DOM.Actions.ReplaceNode do
  @moduledoc """
  An action that will replace the `:target` node with the `:replacement` node.
  """
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:target, :replacement]
  defstruct [:target, :replacement]

  @type t :: %__MODULE__{
          target: DOM.Node.t(),
          replacement: DOM.Node.t()
        }

  @doc """
  Returns whether the argument is a `t:Tamnoon.DOM.Actions.ReplaceNode.t/0`, or a map with
  the necessary properties to construct one (via `new!/1`).
  """
  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.ReplaceNode{}), do: true

  def is_valid?(%{target: %DOM.Node{}, replacement: %DOM.Node{}}), do: true

  def is_valid?(_), do: false

  @doc """
  Constructs a `t:Tamnoon.DOM.Actions.ReplaceNode.t/0` with the following arguments:

  * `:target`: a `t:Tamnoon.DOM.Node.t/0`.

  * `:replacement`: a `t:Tamnoon.DOM.Node.t/0`.
  """
  @spec new!(action_args :: term()) :: %DOM.Actions.ReplaceNode{}
  def new!(%DOM.Actions.ReplaceNode{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.ReplaceNode)

    struct!(DOM.Actions.ReplaceNode, action_args)
  end
end
