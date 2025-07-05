defmodule Tamnoon.DOM.Actions.RemoveNode do
  alias Tamnoon.DOM
  import DOM
  use DOM.Actions.ActionEncoder

  @enforce_keys [:target]
  defstruct [:target]

  @type t :: %__MODULE__{
          target: DOM.Node.t(),
        }

  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.RemoveNode{}), do: true

  def is_valid?(%{target: %DOM.Node{}}), do: true

  def is_valid?(_), do: false


  @spec new!(action_args :: term()) :: %DOM.Actions.RemoveNode{}
  def new!(%DOM.Actions.RemoveNode{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.RemoveNode)

    struct!(DOM.Actions.RemoveNode, action_args)
  end
end
