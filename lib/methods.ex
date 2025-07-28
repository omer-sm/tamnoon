defmodule Tamnoon.Methods do
  @moduledoc """
  A _methods module_ that provides built-in methods for use in your Tamnoon application.

  This module offers utilities for basic state management via `tmnn_get/2` and `tmnn_update/2`,
  as well as PubSub functionality through `tmnn_sub/2`, `tmnn_unsub/2`, `tmnn_pub/2` and `subbed_channels/0`.

  Most of these methods are primarily intended either to be used internally by Tamnoon,
  or to be triggered from Tamnoon HEEx markup.

  This module is automatically included as a _methods module_ by Tamnoon.

  _Note: In the documentation for the built-in methods, the term "returns" may refer to
  either the function's return value or the value included in the server's response to the
  client. The context should clarify which is meant._
  """
  require Logger

  @doc """
  Returns the field from the state corresponding to the `:key` specified in the request.
  If the key is not present in the state, returns an error string.

  #### Example

  ```html
  <button onclick=@get-mydata>Refresh</button>
  <p>@mydata</p>
  ```

  In this example, clicking the button triggers the `:get` method with the key `:mydata`,
  updating the contents of the `<p>` element to reflect the current value of `:mydata` in the state.

  _Note: In typical usage, method return values should keep the client state in sync automatically,
  making manual `:get` calls unnecessary in most cases._
  """
  @spec tmnn_get(map(), map()) ::
          {field :: map(), [], state :: map()}
          | {%{error: error :: String.t()}, [], state :: map()}
  def tmnn_get(req, state), do: get(req, state)

  @doc """
  Updates the value of the field specified by the `"key"` in the request,
  setting it to the value provided under the `"value"` key. Returns the updated field value,
  or an error string if the field does not exist.

  #### Example

  ```html
  <input onchange=@update-name placeholder="Enter your name..">
  <p>Your name is: <span>@name</span></p>
  ```

  In the example above, each time the `<input>` changes, the `:name` field in the state will
  be updated. The updated value will be automatically reflected in the `<p>` element.

  #### Usage with other elements

  This method can also be used with elements that don’t have an intrinsic value
  (like `<button>`) by explicitly providing a value attribute:

  ```html
  <button onclick=@update-theme value="dark">Dark mode</button>
  ```

  In this example, clicking the button sets the `:theme` field in the state to `"dark"`.
  """
  @spec tmnn_update(map(), map()) ::
          {new_field :: map()} | {%{error: error :: String.t()}, [], state :: map()}
  def tmnn_update(req, state), do: update(req, state)

  @doc """
  Subscribes the client to the channel specified under the `"channel"` field in the request.
  If the channel does not exist, it will be created automatically. If the client is already
  subscribed to the channel, the call has no effect.

  ```
  defmethod :switch_room do
    target_room_id = req["value"]

    Tamnoon.Methods.unsub(%{"channel" => "room_\#{state[:current_room_id]}"}, state)
    Tamnoon.Methods.sub(%{"channel" => "room_\#{target_room_id}"}, state)

    {%{current_room_id: target_room_id}}
  end
  ```

  In the example above, the `:switch_room` method unsubscribes the client from their
  currently joined room and subscribes them to a new room with the key `"room_<id>"`.
  """
  @spec tmnn_sub(map(), map()) :: {%{sub: :ok}, [], state :: map()}
  def tmnn_sub(req, state), do: sub(req, state)

  @doc """
  Broadcasts a request to all clients subscribed to the channel specified under the
  `"channel"` key. The request to be sent is provided under the `"action"` key, and will be
  treated as a regular method call on the receiving clients.

  #### Example

  ```
  defmethod :send_message do
    %{
      message_content: message_content,
      current_room_id: current_room_id
    } = state

    Tamnoon.Methods.pub(%{
          "channel" => "room_\#{current_room_id}",
          "action" => %{
            "method" => "add_message",
            "message" => message_content
          }
        }, state)

    {%{message_content: ""}}
  end
  ```

  In the example above, the `:send_message` method broadcasts an `:add_message` method call
  to all clients in the current room. The broadcasted request includes a `"message"` field
  with the content of the message.
  """
  @spec tmnn_pub(map(), map()) :: {%{pub: :ok}, [], state :: map()}
  def tmnn_pub(req, state), do: pub(req, state)

  @doc """
  Unsubscribes the client from the channel specified under the `"channel"` field in the request.
  If the client is not already subscribed to the channel or it does not exist, the call has
  no effect. Will return an error string if trying to unsubscribe from the `"clients"` channel.

  ```
  defmethod :switch_room do
    target_room_id = req["value"]

    Tamnoon.Methods.unsub(%{"channel" => "room_\#{state[:current_room_id]}"}, state)
    Tamnoon.Methods.sub(%{"channel" => "room_\#{target_room_id}"}, state)

    {%{current_room_id: target_room_id}}
  end
  ```

  In the example above, the `:switch_room` method unsubscribes the client from their
  currently joined room and subscribes them to a new room with the key `"room_<id>"`.
  """
  @spec tmnn_unsub(map(), map()) ::
          {%{unsub: :ok}, [], state :: map()}
          | {%{error: error :: String.t()}, [], state :: map()}
  def tmnn_unsub(req, state), do: unsub(req, state)

  @doc """
  Logs the `req` to the console. This method is primarily intended for debugging purposes.
  """
  @spec tmnn_debug(map(), map()) :: {}
  def tmnn_debug(req, state), do: debug(req, state)

  @doc """
  Returns the current state. This method is automatically invoked when a client
  connection is established. Intended for internal use by Tamnoon.
  """
  @spec tmnn_sync(map(), map()) :: {state :: map(), [], state :: map()}
  def tmnn_sync(req, state), do: sync(req, state)

  @doc """
  Invoked every 55 seconds by the client in order to prevent idle timeouts. Intended for
  internal use by Tamnoon.
  """
  @spec tmnn_keep_alive(map(), map()) :: {nil, [], state :: map()}
  def tmnn_keep_alive(req, state), do: keep_alive(req, state)

  @doc """
  Sets the server state to the value provided by the client. This is automatically invoked when the client
  reconnects, helping to restore the previous state and prevent information loss.
  Intended for internal use by Tamnoon.
  """
  @spec tmnn_set_state(map(), map()) :: {%{set_state: :ok}, [], state :: map()}
  def tmnn_set_state(req, state), do: set_state(req, state)

  @doc false
  def get(req, state) do
    key = get_key(req, state)

    if key != nil do
      {%{key => state[key]}, [], state}
    else
      {%{error: "Error: no matching key"}, [], state}
    end
  end

  @doc false
  def update(req, state) do
    key = get_key(req, state)

    if key != nil do
      {%{key => req["value"]}}
    else
      {%{error: "Error: no matching key"}, [], state}
    end
  end

  @doc false
  def sub(req, state) do
    if !is_subbed?(req["channel"]) do
      Tamnoon.Registry
      |> Registry.register(req["channel"], {})
    end

    {%{sub: :ok}, [], state}
  end

  @doc false
  def unsub(req, state) do
    cond do
      req["channel"] == "clients" ->
        {%{error: "Error: can't unsub from clients channel"}, [], state}

      is_subbed?(req["channel"]) ->
        Tamnoon.Registry
        |> Registry.unregister(req["channel"])

        {%{unsub: :ok}, [], state}

      true ->
        {%{unsub: :ok}, [], state}
    end
  end

  @doc false
  def pub(req, state) do
    Tamnoon.Registry
    |> Registry.dispatch(req["channel"], fn entries ->
      for {pid, _} <- entries do
        Process.send(pid, elem(Jason.encode(req["action"]), 1), [])
      end
    end)

    {%{pub: :ok}, [], state}
  end

  @doc false
  def sync(_req, state) do
    {state, [], state}
  end

  @doc false
  def keep_alive(_req, state) do
    {nil, [], state}
  end

  @doc false
  def set_state(req, _state) do
    new_state = for {key, val} <- req["state"], into: %{}, do: {String.to_atom(key), val}
    {%{set_state: :ok}, [], new_state}
  end

  @doc false
  def debug(req, _state) do
    Logger.debug("Debug method called with request: #{inspect(req)}")
    {}
  end

  @doc """
  Returns the value of the key under the field `"key"` in the request as an atom.
  Note: this is not a method handler - simply a utility function.
  """
  @spec get_key(map(), map()) :: atom() | nil
  def get_key(req, state) do
    cond do
      Map.has_key?(state, req["key"]) -> req["key"]
      Map.has_key?(state, String.to_atom(req["key"])) -> String.to_atom(req["key"])
      true -> nil
    end
  end

  @doc """
  Returns a list of the channels the client is currently subscribed to.
  """
  @spec subbed_channels() :: [term()]
  def subbed_channels(),
    do:
      Tamnoon.Registry
      |> Registry.keys(self())

  defp is_subbed?(key) do
    Tamnoon.Registry
    |> Registry.lookup(key)
    |> Enum.any?(fn {pid, _} -> pid == self() end)
  end
end
