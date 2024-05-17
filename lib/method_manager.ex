defmodule Tamnoon.MethodManager do
  @moduledoc """
  This module handles the management of different methods as you create them.
  Notably, it provides the `defmethod/2` macro.
  > #### Importing the module {: .info}
  > In order to create handlers for the methods you set up, you must `import Tamnoon.MethodManager`
  > in your _methods module_. Then, you can use the `defmethod/2` macro to implement handling
  > of the methods.
  """

  @doc """
  Defines a function named `tmnn_[name]`. Functions with this prefix in your _methods module_
  will automatically be added to the possible methods when invoking `route_request/3`.
  Inside the created function, you can access the state of the client and the request
  object by the `state` and `req` variables respectively.
  Method handlers must return a tuple of `{return_value, new_state}`.
  ## Example
  ```
  defmethod :get do
    key = get_key(req, state)
    if (key != nil) do
      {state[key], state}
    else
      {"Error: no matching key", state}
    end
  end
  ```
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

  @doc """
  The function used by `Tamnoon.SocketHandler.websocket_handle/2` to route the requests
  to the appropriate method handler.
  """
  @spec route_request(module(), map(), map()) :: {:reply, {:text, return_value :: String.t()}, new_state :: map()}
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
