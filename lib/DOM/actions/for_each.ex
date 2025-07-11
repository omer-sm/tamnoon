defmodule Tamnoon.DOM.Actions.ForEach do
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:target, :callback]
  defstruct [:target, :callback]

  @type t :: %__MODULE__{
          target: DOM.NodeCollection.t(),
          callback: struct()
        }

  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.ForEach{}), do: true

  def is_valid?(%{target: %DOM.NodeCollection{}, callback: %_{}}), do: true

  def is_valid?(_), do: false

  @spec new!(action_args :: term()) :: %DOM.Actions.ForEach{}
  def new!(%DOM.Actions.ForEach{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.ForEach)

    struct!(DOM.Actions.ForEach, action_args)
  end
end
