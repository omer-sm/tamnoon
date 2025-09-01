defmodule Tamnoon.LiveReload do
  @moduledoc false
  require Logger

  def try_recompile() do
    if is_live_reload_on?() do
      if IEx.Helpers.recompile() == :ok do
        Logger.info("Live reload: recompiled successfully.")

        application_file_stat =
          Path.wildcard("lib/**/application.ex")
          |> List.first()
          |> File.stat()

        case application_file_stat do
          {:ok, stat} -> maybe_warn_about_application_file(stat)
          {:error, reason} -> raise "Live reload: failed to find application.ex file (#{inspect(reason)})."
        end
      end
    end
  end

  defp maybe_warn_about_application_file(application_file_stat) do
    last_change_time =
      NaiveDateTime.from_erl!(application_file_stat.mtime)
      |> DateTime.from_naive("Etc/UTC")
      |> elem(1)

    unless DateTime.compare(last_change_time, app_start_time()) == :lt, do:
      Logger.warning("Live reload: detected a change in application.ex. The server must be restarted in order to load the changes.")
  end

  defp is_live_reload_on?(),
    do:
      Tamnoon.Registry
      |> Registry.meta(:live_reload)
      |> elem(1)

  defp app_start_time(),
    do:
      Tamnoon.Registry
      |> Registry.meta(:app_start_time)
      |> elem(1)
end
