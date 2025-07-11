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
  Defines a function named `tmnn_[name]`. Functions with this prefix in your _methods module_
  will automatically be added to the possible methods when invoking `route_request/3`.
  Inside the created function, you can access the state of the client and the request
  object by the `state` and `req` variables respectively.
  Method handlers must return a tuple of `{return_value, new_state}` (note: use `diff/2` for a shorter version).
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
        # Use the `req` variable to stop unused variable warnings.
        _ = var!(req)

        var!(state) = state
        unquote(block)
      end
    end
  end

  @doc """
  The function used by `Tamnoon.SocketHandler.websocket_handle/2` to route the requests
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
        {diffs, new_state} ->
          {:reply, {:text, elem(Jason.encode(%{diffs: diffs}, []), 1)}, new_state}

        {diffs, new_state, actions} ->
          {:reply, {:text, elem(Jason.encode(%{diffs: diffs, actions: actions}, []), 1)},
           new_state}

        _ ->
          Logger.warning(
            "Method '#{method}' returned an invalid value '#{inspect(method_results)}'. Methods must return a {diffs, new_state} tuple or a {diffs, new_state, actions} tuple."
          )

          {:reply, {:text, elem(Jason.encode(%{diffs: %{}}, []), 1)}, state}
      end
    end
  end

  @doc """
  Returns a tuple containing the diffs and the new state after applying the diffs.
  Additionally, Actions can be passed to the third argument in order to include them as well.
  Can be used in method handlers to update a value easily.
  ## Example
  ```
  defmethod :change_something do
    diffs = %{some_key: "New value", another_key: "Another value"}

    diff(diffs, state)
  end
  ```
  """
  @spec diff(map(), map(), list() | nil) :: {map(), map()} | {map(), map(), list()}
  def diff(diffs, state, actions \\ nil)

  def diff(diffs, state, nil) do
    {diffs, Map.merge(state, diffs, fn _key, _old, new -> new end)}
  end

  def diff(diffs, state, actions) do
    {diffs, Map.merge(state, diffs, fn _key, _old, new -> new end), actions}
  end

  @doc """
  Triggers a method with the given name and payload. An additional timeout can be specified
  to delay the triggering of the method.
  """
  @spec trigger_method(atom(), map(), non_neg_integer()) ::
          :ok | :noconnect | :nosuspend | reference()
  def trigger_method(method_name, payload, timeout \\ 0)

  def trigger_method(method, req, 0) do
    Process.send(self(), Jason.encode!(Map.merge(req, %{method: method})), [])
  end

  def trigger_method(method, req, timeout) do
    Process.send_after(self(), Jason.encode!(Map.merge(req, %{method: method})), timeout)
  end
end
