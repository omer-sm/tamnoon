defmodule Tamnoon.Methods do
  @moduledoc """
  Provides default implementations for methods you need to get your Tamnoon server
  working - basic state management (with `tmnn_get/2` and `tmnn_update/2`) and basic handling of
  PubSub channels (via `tmnn_sub/2`, `tmnn_unsub/2`, `tmnn_pub/2`, `tmnn_subbed_channels/2`)
  > #### Using the module {: .info}
  > Since v1.0.0-a.4, you should import `Tamnoon.MethodManager` in your _methods modules_ instead of using this module directly.

  _Note: in the documentation of the default methods, the term 'returns' is used both
  to describe the return value of the function and the value of the server's response._
  """

  @deprecated "since v1.0.0-a.4, import `Tamnoon.MethodManager` instead of using this module."
  defmacro __using__(_opts \\ []) do
    quote do
      import Tamnoon.MethodManager

      import Tamnoon.Methods,
        except: [
          tmnn_get: 2,
          tmnn_update: 2,
          tmnn_sub: 2,
          tmnn_pub: 2,
          tmnn_unsub: 2,
          tmnn_subbed_channels: 2,
          tmnn_sync: 2,
          tmnn_keep_alive: 2,
          tmnn_set_state: 2
        ]

      def tmnn_get(req, state), do: get(req, state)
      def tmnn_update(req, state), do: update(req, state)
      def tmnn_sub(req, state), do: sub(req, state)
      def tmnn_pub(req, state), do: pub(req, state)
      def tmnn_unsub(req, state), do: unsub(req, state)
      def tmnn_subbed_channels(req, state), do: subbed_channels(req, state)
      def tmnn_sync(req, state), do: sync(req, state)
      def tmnn_keep_alive(req, state), do: keep_alive(req, state)
      def tmnn_set_state(req, state), do: set_state(req, state)
    end
  end

  @doc """
  Returns the field with the key specified under the `"key"` field
  in the request. Returns an error string if there is no such item.
  """
  @spec tmnn_get(map(), map()) ::
          {field :: map(), state :: map()} | {%{error: error :: String.t()}, state :: map()}
  def tmnn_get(req, state), do: get(req, state)

  @doc """
  Updates the value of the item with the key at the `"key"` field on the request,
  setting it to the value at the `"value"` key. Returns a tuple with the updated field and
  the state, or an error string if there is no such item.
  """
  @spec tmnn_update(map(), map()) ::
          {new_field :: map(), state :: map()} | {%{error: error :: String.t()}, state :: map()}
  def tmnn_update(req, state), do: update(req, state)

  @doc """
  Subscribes to the channel under the `"key"` field in the request. If there is no such
  channel, one will be created (with the client subscribed to it).
  If the client is already subscribed to the channel nothing will happen.
  """
  @spec tmnn_sub(map(), map()) :: {%{sub: :ok}, state :: map()}
  def tmnn_sub(req, state), do: sub(req, state)

  @doc """
  Will send the request under the `"action"` key in the request to every client
  in the channel under the `"channel"` key.
  """
  @spec tmnn_pub(map(), map()) :: {%{pub: :ok}, state :: map()}
  def tmnn_pub(req, state), do: pub(req, state)

  @doc """
  Unsubscribes from the channel under the `"key"` in the request.
  """
  @spec tmnn_unsub(map(), map()) ::
          {%{unsub: :ok}, state :: map()} | {%{error: error :: String.t()}, state :: map()}
  def tmnn_unsub(req, state), do: unsub(req, state)

  @doc """
  Returns a list of the channels the client is currently subscribed to.
  """
  @spec tmnn_subbed_channels(map(), map()) ::
          {%{subbed_channels: channels :: [String.t()]}, state :: map()}
  def tmnn_subbed_channels(req, state), do: subbed_channels(req, state)

  @doc """
  Returns the current state. Automatically invoked when the connection is started.
  """
  @spec tmnn_sync(map(), map()) :: {state :: map(), state :: map()}
  def tmnn_sync(req, state), do: sync(req, state)

  @doc """
  Invoked every 55 seconds by the client in order to prevent idle timeouts.
  """
  @spec tmnn_keep_alive(map(), map()) :: {nil, state :: map()}
  def tmnn_keep_alive(req, state), do: keep_alive(req, state)

  @doc """
  Sets the state on the server to the state sent by the client. Invoked when the client reconnects
  to the server in order to prevent information loss.
  """
  @spec tmnn_set_state(map(), map()) :: {%{set_state: :ok}, state :: map()}
  def tmnn_set_state(req, state), do: set_state(req, state)

  @doc false
  def get(req, state) do
    key = get_key(req, state)

    if key != nil do
      {%{key => state[key]}, state}
    else
      {%{error: "Error: no matching key"}, state}
    end
  end

  @doc false
  def update(req, state) do
    key = get_key(req, state)

    if key != nil do
      {%{key => req["value"]}, Map.put(state, key, req["value"])}
    else
      {%{error: "Error: no matching key"}, state}
    end
  end

  @doc false
  def sub(req, state) do
    if !is_subbed?(req["key"]) do
      Tamnoon.Registry
      |> Registry.register(req["key"], {})
    end

    {%{sub: :ok}, state}
  end

  @doc false
  def unsub(req, state) do
    cond do
      req["key"] == "clients" ->
        {%{error: "Error: can't unsub from clients channel"}, state}

      is_subbed?(req["key"]) ->
        Tamnoon.Registry
        |> Registry.unregister(req["key"])

        {%{unsub: :ok}, state}

      true ->
        {%{unsub: :ok}, state}
    end
  end

  @doc false
  def subbed_channels(_req, state) do
    channels =
      Tamnoon.Registry
      |> Registry.keys(self())

    {%{subbed_channels: channels}, state}
  end

  @doc false
  def pub(req, state) do
    Tamnoon.Registry
    |> Registry.dispatch(req["channel"], fn entries ->
      for {pid, _} <- entries do
        Process.send(pid, elem(Jason.encode(req["action"]), 1), [])
      end
    end)

    {%{pub: :ok}, state}
  end

  @doc false
  def sync(_req, state) do
    {state, state}
  end

  @doc false
  def keep_alive(_req, state) do
    {nil, state}
  end

  @doc false
  def set_state(req, _state) do
    new_state = for {key, val} <- req["state"], into: %{}, do: {String.to_atom(key), val}
    {%{set_state: :ok}, new_state}
  end

  @doc """
  Returns the value of the key under the field `"key"` in the request as an atom.
  Note: this is *NOT* a method handler - simply a utility function.
  """
  @spec get_key(map(), map()) :: atom() | nil
  def get_key(req, state) do
    cond do
      Map.has_key?(state, req["key"]) -> req["key"]
      Map.has_key?(state, String.to_atom(req["key"])) -> String.to_atom(req["key"])
      true -> nil
    end
  end

  defp is_subbed?(key) do
    Tamnoon.Registry
    |> Registry.lookup(key)
    |> Enum.any?(fn {pid, _} -> pid == self() end)
  end
end
