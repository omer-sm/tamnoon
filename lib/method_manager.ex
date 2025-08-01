defmodule Tamnoon.MethodManager do
  @moduledoc """
  This module handles the management of different methods as you create them.
  Notably, it provides the `defmethod/2` macro.

  > #### Importing the module {: .info}
  > In order to create handlers for the methods you set up, you must `import Tamnoon.MethodManager`
  > in your _methods module_. Then, you can use the `defmethod/2` macro to implement handling
  > of the methods.
  """
  require Logger

  @doc """
  Defines a _method_. Methods are functions that can be triggered via Tamnoon HEEx code
  (see the _Methods_ guide for more info).

  Methods receive the `state` map and a `req` map. The `state` is the current state of
  the app, and `req` is a map containing info about the invocation - specifically:

  - `:value`: The invoking element's value.
  - `:key`: The _key_ given to the method (for example, an element with
    `onclick=@update-name` will have `"name"` as the `:key`). Is included only when a key
    is given.
  - `:element`: The raw HTML of the invoking element.

  Methods must return either a tuple of the form `{}`, `{diffs}`, `{diffs, actions}`, or `{diffs, actions, new_state}` where:

  - _diffs_: A map containing the changes in the state (will be updated in the client).
  - _actions_: a list of _actions_ (see `m:Tamnoon.DOM`).
  - _new\_state_: A map which will be set as the new state (if not provided, the current state will be automatically merged with `diffs`).

  Under the hood, it defines a function named `tmnn_[name]`. Functions with this prefix in your
  _methods modules_ will automatically be added to the possible methods when invoking `route_request/3`.

  ## Example
  ```
  defmethod :get do
    key = get_key(req, state)

    if key != nil do
      {%{key => state[key]}, [], state}
    else
      {%{error: "Error: no matching key"}, [], state}
    end
  end
  ```
  """
  defmacro defmethod(name, do: block) do
    method_name = String.to_atom("tmnn_" <> Atom.to_string(name))

    quote do
      def unquote(method_name)(req, state) do
        var!(state) = state
        # Use the `state` variable to stop unused variable warnings.
        cond do
          true -> _ = var!(state)
        end

        var!(req) = req
        # Use the `req` variable to stop unused variable warnings.
        _ = var!(req)


        unquote(block)
      end
    end
  end

  @doc """
  The function used internally by `Tamnoon.SocketHandler.websocket_handle/2` to route the requests
  to the appropriate method handler.
  """
  @spec route_request(list(module()), map(), map()) ::
          {:reply, {:text, return_value :: String.t()}, new_state :: map()}
  def route_request(methods_modules, payload, state) do
    method = payload["method"]

    found_func_info =
      Enum.find_value(methods_modules, fn methods_module ->
        func_info =
          methods_module.__info__(:functions)
          |> Enum.find(fn {name, arity} ->
            arity == 2 && Atom.to_string(name) == "tmnn_" <> method
          end)

        if func_info, do: {methods_module, func_info}, else: nil
      end)

    if found_func_info == nil do
      Logger.error("Method '#{method}' not found in any methods module.")

      {:reply, {:text, elem(Jason.encode(%{error: "Method '#{method}' not found."}, []), 1)},
       state}
    else
      {methods_module, {func, _arity}} = found_func_info

      {method_results, []} =
        quote do
          unquote(methods_module).unquote(func)(
            unquote(Macro.escape(payload)),
            unquote(Macro.escape(state))
          )
        end
        |> Code.eval_quoted()

      case method_results do
        {} -> {:reply, {:text, elem(Jason.encode(%{}, []), 1)}, state}

        {diffs} ->
          new_state = merge_state(diffs, state)
          {:reply, {:text, elem(Jason.encode(%{diffs: diffs}, []), 1)}, new_state}

        {diffs, actions} ->
          new_state = merge_state(diffs, state)

          {:reply, {:text, elem(Jason.encode(%{diffs: diffs, actions: actions}, []), 1)},
           new_state}

        {diffs, actions, new_state} ->
          {:reply, {:text, elem(Jason.encode(%{diffs: diffs, actions: actions}, []), 1)},
           new_state}

        _ ->
          Logger.warning(
            "Method '#{method}' returned an invalid value '#{inspect(method_results)}'. Methods must return a tuple of the form {}, {diffs}, {diffs, actions}, or {diffs, actions, new_state}."
          )

          {:reply, {:text, elem(Jason.encode(%{diffs: %{}}, []), 1)}, state}
      end
    end
  end

  @doc """
  Triggers a method with the given name and payload. An additional timeout (in milliseconds) can be specified
  to delay the triggering of the method.
  """
  @spec trigger_method(atom(), map(), non_neg_integer()) ::
          :ok | :noconnect | :nosuspend | reference()
  def trigger_method(method_name, payload, timeout_ms \\ 0)

  def trigger_method(method, req, 0) do
    Process.send(self(), Jason.encode!(Map.merge(req, %{method: method})), [])
  end

  def trigger_method(method, req, timeout_ms) do
    Process.send_after(self(), Jason.encode!(Map.merge(req, %{method: method})), timeout_ms)
  end

  defp merge_state(diffs, state) do
    Map.merge(state, diffs, fn _key, _old, new -> new end)
  end
end
