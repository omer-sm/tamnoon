defmodule Mix.Tasks.Tamnoon.MakeDirs do
  @moduledoc """
  Creates a "components" directory inside "lib" and a "tamnoon_out" directory in the root of the project.

  #### Example Usage

  ```console
  $ mix tamnoon.make_dirs

  Successfully created "lib/components"!
  Successfully created "tamnoon_out"!
  ```
  """
  @shortdoc "Creates the directories needed for Tamnoon to function"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    if File.dir?("lib/components") do
      Mix.shell().info("Directory \"lib/components\" already exists, skipping..")
    else
      :ok = File.mkdir("lib/components")
      Mix.shell().info("Successfully created \"lib/components\"!")
    end

    if File.dir?("tamnoon_out") do
      Mix.shell().info("Directory \"tamnoon_out\" already exists, skipping..")
    else
      :ok = File.mkdir("tamnoon_out")
      Mix.shell().info("Successfully created \"tamnoon_out\"!")
    end
  end
end
