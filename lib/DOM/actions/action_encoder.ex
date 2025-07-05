defmodule Tamnoon.DOM.Actions.ActionEncoder do
  def encode_action(value, opts) do
    %{
      action: Module.split(value.__struct__) |> List.last(),
      args: Map.from_struct(value)
    }
    |> Jason.Encode.map(opts)
  end

  defmacro __using__(_) do
    quote do
      defimpl Jason.Encoder, for: __MODULE__ do
        def encode(value, opts), do: Tamnoon.DOM.Actions.ActionEncoder.encode_action(value, opts)
      end
    end
  end
end
