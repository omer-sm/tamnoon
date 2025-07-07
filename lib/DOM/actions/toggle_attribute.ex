defmodule Tamnoon.DOM.Actions.ToggleAttribute do
  alias Tamnoon.DOM
  import DOM
  use DOM.Actions.ActionEncoder

  @enforce_keys [:target, :attribute]
  defstruct [:target, :attribute, :force]

  @type t :: %__MODULE__{
          target: DOM.Node.t(),
          attribute: String.t(),
          force: boolean() | nil
        }

  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.ToggleAttribute{}), do: true

  def is_valid?(%{target: %DOM.Node{}, attribute: attribute, force: force})
      when is_binary(attribute) and is_boolean(force),
      do: true

  def is_valid?(%{target: %DOM.Node{}, attribute: attribute})
      when is_binary(attribute),
      do: true

  def is_valid?(_), do: false

  @spec new!(action_args :: term()) :: %DOM.Actions.ToggleAttribute{}
  def new!(%DOM.Actions.ToggleAttribute{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.ToggleAttribute)

    struct!(DOM.Actions.ToggleAttribute, action_args)
  end
end
