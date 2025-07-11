defmodule Tamnoon.DOM.Actions.ToggleAttribute do
  @moduledoc """
  An action that will toggle `:attribute` attribute of the `:target` node. An additional
  argument `:force` can also be provided in order to force the value as `true` or `false`.
  """
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:target, :attribute]
  defstruct [:target, :attribute, :force]

  @type t :: %__MODULE__{
          target: DOM.Node.t(),
          attribute: String.t(),
          force: boolean() | nil
        }

        @doc """
  Returns whether the argument is a `t:Tamnoon.DOM.Actions.ToggleAttribute.t/0`, or a map with
  the necessary properties to construct one (via `new!/1`).
  """
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

  @doc """
  Constructs a `t:Tamnoon.DOM.Actions.SetValue.t/0` with the following arguments:

  * `:target`: a `t:Tamnoon.DOM.Node.t/0`.

  * `:attribute`: a `t:String.t/0`.

  * `:force`: a boolean (optional).
  """
  @spec new!(action_args :: term()) :: %DOM.Actions.ToggleAttribute{}
  def new!(%DOM.Actions.ToggleAttribute{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.ToggleAttribute)

    struct!(DOM.Actions.ToggleAttribute, action_args)
  end
end
