defmodule Tamnoon.DOM.Actions.SetAttribute do
  @moduledoc """
  An action that will set the `:attribute` attribute of the `:target` node
  to `:value`. Can also be used to set the `textContent` of a node by passing `"textContent"`
  to `:attribute`.
  """
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

  @doc """
  Returns whether the argument is a `t:Tamnoon.DOM.Actions.SetAttribute.t/0`, or a map with
  the necessary properties to construct one (via `new!/1`).
  """
  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.SetAttribute{}), do: true

  def is_valid?(%{target: %DOM.Node{}, attribute: attribute, value: value})
      when is_binary(attribute) and (is_binary(value) or is_boolean(value) or is_number(value)),
      do: true

  def is_valid?(_), do: false

  @doc """
  Constructs a `t:Tamnoon.DOM.Actions.SetAttribute.t/0` with the following arguments:

  * `:target`: a `t:Tamnoon.DOM.Node.t/0`.

  * `:attribute`: a `t:String.t/0`.

  * `:value`: a `t:String.t/0`, boolean or number.
  """
  @spec new!(action_args :: term()) :: %DOM.Actions.SetAttribute{}
  def new!(%DOM.Actions.SetAttribute{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.SetAttribute)

    struct!(DOM.Actions.SetAttribute, action_args)
  end
end
