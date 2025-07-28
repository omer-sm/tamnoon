defmodule Mix.Tasks.Tamnoon.Setup do
  @moduledoc """
  Runs all the necessary Tamnoon setup tasks.

  #### Example Usage

  ```console
  $ mix tamnoon.setup

  Running make_dirs task..
  ...
  Running override_root task..
  ...
  ```
  """
  @shortdoc "Runs all the necessary Tamnoon setup tasks"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info("Running make_dirs task..")
    Mix.Tasks.Tamnoon.MakeDirs.run([])
    Mix.shell().info("Running override_root task..")
    Mix.Tasks.Tamnoon.OverrideRoot.run([])
  end
end
