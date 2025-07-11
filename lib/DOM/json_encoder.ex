defmodule Tamnoon.DOM.JsonEncoder do
  @moduledoc false
  @type dom_struct_type() :: :action | :node | :node_collection

  @spec encode_dom_struct(value :: struct(), opts :: term(), type :: dom_struct_type()) ::
          iodata()
  def encode_dom_struct(value, opts, type)

  def encode_dom_struct(%{__struct__: module} = value, opts, :action) do
    %{
      type: :action,
      action: Module.split(module) |> List.last(),
      args: Map.from_struct(value)
    }
    |> Jason.Encode.map(opts)
  end

  def encode_dom_struct(%{__struct__: _} = value, opts, type)
      when type in [:node, :node_collection] do
    Map.from_struct(value)
    |> Jason.Encode.map(opts)
  end

  defmacro __using__(opts) do
    quote do
      defimpl Jason.Encoder, for: __MODULE__ do
        def encode(value, jason_opts),
          do:
            Tamnoon.DOM.JsonEncoder.encode_dom_struct(
              value,
              jason_opts,
              unquote(Keyword.get(opts, :type))
            )
      end
    end
  end
end
