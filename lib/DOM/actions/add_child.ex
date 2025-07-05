defmodule Tamnoon.DOM.Actions.AddChild do
  alias Tamnoon.DOM
  import DOM
  use DOM.Actions.ActionEncoder

  @enforce_keys [:parent, :child]
  defstruct [:parent, :child]

  @type t :: %__MODULE__{
          parent: DOM.Node.t(),
          child: DOM.Node.t()
        }

  @spec is_valid?(action_args :: any()) :: boolean()
  def is_valid?(action_args)

  def is_valid?(%DOM.Actions.AddChild{}), do: true

  def is_valid?(%{parent: %DOM.Node{}, child: %DOM.Node{}}), do: true

  def is_valid?(_), do: false


  @spec new!(action_args :: term()) :: %DOM.Actions.AddChild{}
  def new!(%DOM.Actions.AddChild{} = action_args), do: action_args

  def new!(action_args) do
    validate_type!(action_args, &is_valid?/1, DOM.Actions.AddChild)

    struct!(DOM.Actions.AddChild, action_args)
  end
end
