defmodule Tamnoon.DOM.Actions.RemoveNode do
  @moduledoc """
  An action that will remove the `:target` node from the DOM.
  """
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:target]
  defstruct [:target]

  @type t :: %__MODULE__{
          target: DOM.Node.t()
        }

  @doc """
  Returns whether the argument is a `t:Tamnoon.DOM.Actions.RemoveNode.t/0`, or a map with
  the necessary properties to construct one (via `new!/1`).
  """
  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.RemoveNode{}), do: true

  def is_valid?(%{target: %DOM.Node{}}), do: true

  def is_valid?(_), do: false

  @doc """
  Constructs a `t:Tamnoon.DOM.Actions.RemoveNode.t/0` with the following argument:

  * `:target`: a `t:Tamnoon.DOM.Node.t/0`.
  """
  @spec new!(action_args :: term()) :: %DOM.Actions.RemoveNode{}
  def new!(%DOM.Actions.RemoveNode{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.RemoveNode)

    struct!(DOM.Actions.RemoveNode, action_args)
  end
end
