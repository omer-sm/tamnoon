defmodule Tamnoon.DOM.Actions.AddChild do
  @moduledoc """
  An action that will append the `:child` node to the `:parent` node's children.
  """
  alias Tamnoon.DOM
  import DOM
  use DOM.JsonEncoder, type: :action

  @enforce_keys [:parent, :child]
  defstruct [:parent, :child]

  @type t :: %__MODULE__{
          parent: DOM.Node.t(),
          child: DOM.Node.t()
        }

  @doc """
  Returns whether the argument is a `t:Tamnoon.DOM.Actions.AddChild.t/0`, or a map with
  the necessary properties to construct one (via `new!/1`).
  """
  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.AddChild{}), do: true

  def is_valid?(%{parent: %DOM.Node{}, child: %DOM.Node{}}), do: true

  def is_valid?(_), do: false

  @doc """
  Constructs a `t:Tamnoon.DOM.Actions.AddChild.t/0` with the following arguments:

  * `:parent`: a `t:Tamnoon.DOM.Node.t/0`.

  * `:child`: a `t:Tamnoon.DOM.Node.t/0`.
  """
  @spec new!(action_args :: term()) :: %DOM.Actions.AddChild{}
  def new!(%DOM.Actions.AddChild{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.AddChild)

    struct!(DOM.Actions.AddChild, action_args)
  end
end
