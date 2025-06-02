defmodule Tamnoon.SocketHandler do
  @moduledoc """
  A default `:cowboy_websocket` implementation. Usually there should not be a reason to do anything
  directly with this module, as it gets its options from `Tamnoon.start_link/1` and
  adapts to them automatically. However, it is still documented for the sake of allowing
  extensiblity.
  You can replace the module with a custom one via setting it as the _(drumroll..)_ `:socket_handler`
  key's value in `Tamnoon.start_link/1`'s options.
  """
  require Logger
  @behaviour :cowboy_websocket

  @doc """
  Initiates the websocket connection.
  """
  @impl true
  @spec init(:cowboy_req.req(), map()) ::
          {:cowboy_websocket, req :: :cowboy_req.req(), initial_state :: map(), opts :: map()}
  def init(req, _state) do
    {:cowboy_websocket, req, initial_state(), %{idle_timeout: 120_000}}
  end

  @doc """
  Initiates the websocket and adds the client to the registry under the `"clients"` channel.
  """
  @impl true
  @spec websocket_init(map()) :: {:ok, state :: map()}
  def websocket_init(state) do
    Tamnoon.Registry
    |> Registry.register("clients", {})

    {:ok, state}
  end

  @doc """
  Receives a websocket request and decodes it, sending it to the `Tamnoon.MethodManager.route_request/3`
  function.
  """
  @impl true
  @spec websocket_handle({:text, tuple()}, map()) ::
          {:reply, {:text, return_val :: String.t()}, new_state :: map()}
  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)

    if (is_debug_mode?()) do
      Logger.debug("DBG | Received payload: #{inspect(payload)}")
      Logger.debug("DBG | Current state: #{inspect(state)}")
    end

    Tamnoon.MethodManager.route_request(methods_module(), payload, state)
  end

  @doc """
  Handles messages from other BEAM processes. By default it is only used for handling
  `"pub"` requests, and as such it simply forwards the message to `websocket_handle/2`.
  """
  @impl true
  @spec websocket_info(info :: map(), map()) ::
          {:reply, {:text, return_val :: String.t()}, new_state :: map()}
  def websocket_info(info, state) do
    websocket_handle({:text, info}, state)
  end

  defp initial_state(),
    do:
      Tamnoon.Registry
      |> Registry.meta(:initial_state)
      |> elem(1)
      |> then(fn
        fun when is_function(fun, 0) -> fun.()
        value -> value
      end)

  defp methods_module(),
    do:
      Tamnoon.Registry
      |> Registry.meta(:methods_module)
      |> elem(1)

  defp is_debug_mode?(),
      do:
        Tamnoon.Registry
        |> Registry.meta(:debug_mode)
        |> elem(1)
end
