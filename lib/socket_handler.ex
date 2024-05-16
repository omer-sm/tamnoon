defmodule Tamnoon.SocketHandler do
  @behaviour :cowboy_websocket
  @methods_module Tamnoon.Methods
  @initial_state %{}

  def init(req, initial_state \\ @initial_state) when is_map(initial_state) do
    {:cowboy_websocket, req, initial_state}
  end

  def websocket_init(state) do
    Tamnoon.Registry
    |> Registry.register("clients", {})
    {:ok, state}
  end

  #@callback websocket_handle({:text, json :: tuple()}, state :: map()) :: {:reply, {:text, return_val :: String.t()}, new_state :: map()}
  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    Tamnoon.MethodManager.route_request(@methods_module, payload, state)
  end

  def websocket_info(info, state) do
    websocket_handle({:text, info}, state)
  end
end
