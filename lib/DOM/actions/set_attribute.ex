defmodule Tamnoon.DOM.Actions.SetAttribute do
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:target, :attribute, :value]
  defstruct [:target, :attribute, :value]

  @type t :: %__MODULE__{
          target: DOM.Node.t(),
          attribute: String.t(),
          value: String.t() | boolean() | number()
        }

  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.SetAttribute{}), do: true

  def is_valid?(%{target: %DOM.Node{}, attribute: attribute, value: value})
      when is_binary(attribute) and (is_binary(value) or is_boolean(value) or is_number(value)),
      do: true

  def is_valid?(_), do: false

  @spec new!(action_args :: term()) :: %DOM.Actions.SetAttribute{}
  def new!(%DOM.Actions.SetAttribute{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.SetAttribute)

    struct!(DOM.Actions.SetAttribute, action_args)
  end
end
