defmodule Tamnoon.MethodManager do
  @doc """
  Defines a function named tmnn_[name]. Will automatically be added to the possible
  methods when using `route_request`.
  """
  defmacro defmethod(name, do: block) do
    method_name = String.to_atom("tmnn_" <> Atom.to_string(name))
    quote do
      def unquote(method_name)(req, state) do
        var!(req) = req
        var!(state) = state
        unquote(block)
      end
    end
  end

  def route_request(methods_module, payload, state) do
    method = payload["method"]
    {func, _arity} = methods_module.__info__(:functions)
    |> Enum.find(fn {name, arity} ->
      arity == 2 && Atom.to_string(name) == "tmnn_" <> method
    end)
    {{ret_val, new_state}, []} = quote do
      unquote(methods_module).unquote(func)(unquote(Macro.escape(payload)), unquote(Macro.escape(state)))
    end
    |> Code.eval_quoted()
    {:reply, {:text, elem(Jason.encode(ret_val, []), 1)}, new_state}
  end


end
