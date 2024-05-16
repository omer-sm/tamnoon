defmodule Tamnoon.Methods do
  defmacro __using__(opts \\ []) do
    quote do
      import Tamnoon.MethodManager
      import Tamnoon.Methods
      def tmnn_get(req, state), do: get(req, state)
      def tmnn_update(req, state), do: update(req, state)
      def tmnn_sub(req, state), do: sub(req, state)
      def tmnn_pub(req, state), do: pub(req, state)
      def tmnn_unsub(req, state), do: unsub(req, state)
      def tmnn_subbed_channels(req, state), do: subbed_channels(req, state)
    end
  end

  def tmnn_get(req, state), do: get(req, state)
  def tmnn_update(req, state), do: update(req, state)
  def tmnn_sub(req, state), do: sub(req, state)
  def tmnn_pub(req, state), do: pub(req, state)
  def tmnn_unsub(req, state), do: unsub(req, state)
  def tmnn_subbed_channels(req, state), do: subbed_channels(req, state)

  def get(req, state) do
    key = get_key(req, state)
    if (key != nil) do
      {state[key], state}
    else
      {"Error: no matching key", state}
    end
  end

  def update(req, state) do
    key = get_key(req, state)
    if (key != nil) do
      {req["val"], Map.put(state, key, req["val"])}
    else
      {"Error: no matching key", state}
    end
  end

  def sub(req, state) do
    if (!is_subbed?(req["key"])) do
      Tamnoon.Registry
      |> Registry.register(req["key"], {})
    end
    {:ok, state}
  end

  def unsub(req, state) do
    cond do
      req["key"] == "clients" -> {"Error: can't unsub from clients channel", state}
      is_subbed?(req["key"]) ->
        Tamnoon.Registry
        |> Registry.unregister(req["key"])
        {:ok, state}
      true -> {:ok, state}
    end
  end

  def subbed_channels(_req, state) do
    channels = Tamnoon.Registry
    |> Registry.keys(self())
    {channels, state}
  end

  def pub(req, state) do
    Tamnoon.Registry
    |> Registry.dispatch(req["channel"], fn entries ->
      for {pid, _} <- entries do
        Process.send(pid, elem(Jason.encode(req["action"]), 1), [])
      end
    end)
    {:ok, state}
  end

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
