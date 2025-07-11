defmodule Tamnoon.DOM.Actions.ForEach do
  @moduledoc """
  An action that will trigger the `:callback` action on each element in the
  collection `:target`.
  """
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:target, :callback]
  defstruct [:target, :callback]

  @type t :: %__MODULE__{
          target: DOM.NodeCollection.t(),
          callback: struct()
        }

  @doc """
  Returns whether the argument is a `t:Tamnoon.DOM.Actions.ForEach.t/0`, or a map with
  the necessary properties to construct one (via `new!/1`).

  _Sidenote: this does not verify that the callback is actually an action,
  just that it is a struct._
  """
  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.ForEach{}), do: true

  def is_valid?(%{target: %DOM.NodeCollection{}, callback: %_{}}), do: true

  def is_valid?(_), do: false

  @doc """
  Constructs a `t:Tamnoon.DOM.Actions.ForEach.t/0` with the following arguments:

  * `:target`: a `t:Tamnoon.DOM.NodeCollection.t/0`.

  * `:callback`: any Tamnoon action.
  """
  @spec new!(action_args :: term()) :: %DOM.Actions.ForEach{}
  def new!(%DOM.Actions.ForEach{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.ForEach)

    struct!(DOM.Actions.ForEach, action_args)
  end
end
