defmodule Tamnoon.DOM.Actions.SetValue do
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:target, :value]
  defstruct [:target, :value]

  @type t :: %__MODULE__{
          target: DOM.Node.t(),
          value: String.t() | boolean() | number()
        }

  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.SetValue{}), do: true

  def is_valid?(%{target: %DOM.Node{}, value: value})
      when is_binary(value) or is_boolean(value) or is_number(value),
      do: true

  def is_valid?(_), do: false

  @spec new!(action_args :: term()) :: %DOM.Actions.SetValue{}
  def new!(%DOM.Actions.SetValue{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.SetValue)

    struct!(DOM.Actions.SetValue, action_args)
  end
end
