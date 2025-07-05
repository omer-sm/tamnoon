defmodule Tamnoon.DOM.Actions.ReplaceNode do
  alias Tamnoon.DOM
  import DOM
  use DOM.Actions.ActionEncoder

  @enforce_keys [:target, :replacement]
  defstruct [:target, :replacement]

  @type t :: %__MODULE__{
          target: DOM.Node.t(),
          replacement: DOM.Node.t()
        }

  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.ReplaceNode{}), do: true

  def is_valid?(%{target: %DOM.Node{}, replacement: %DOM.Node{}}), do: true

  def is_valid?(_), do: false


  @spec new!(action_args :: term()) :: %DOM.Actions.ReplaceNode{}
  def new!(%DOM.Actions.ReplaceNode{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.ReplaceNode)

    struct!(DOM.Actions.ReplaceNode, action_args)
  end
end
