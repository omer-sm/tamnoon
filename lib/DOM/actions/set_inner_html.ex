defmodule Tamnoon.DOM.Actions.SetInnerHTML do
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:target, :value]
  defstruct [:target, :value]

  @type t :: %__MODULE__{
          target: DOM.Node.t(),
          value: String.t()
        }

  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.SetInnerHTML{}), do: true

  def is_valid?(%{target: %DOM.Node{}, value: value})
    when is_binary(value), do: true

  def is_valid?(_), do: false

  @spec new!(action_args :: term()) :: %DOM.Actions.SetInnerHTML{}
  def new!(%DOM.Actions.SetInnerHTML{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.SetInnerHTML)

    struct!(DOM.Actions.SetInnerHTML, action_args)
  end
end
