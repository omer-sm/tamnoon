defmodule Tamnoon.LiveReload do
  require Logger

  def try_recompile() do
    if is_live_reload_on?() do
      if IEx.Helpers.recompile() == :ok, do: Logger.info("Live reload: recompiled successfully.")
    end
  end

  defp is_live_reload_on?(),
    do:
      Tamnoon.Registry
      |> Registry.meta(:live_reload)
      |> elem(1)
end
