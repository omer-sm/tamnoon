defmodule Mix.Tasks.Tamnoon.OverrideRoot do
  @moduledoc """
  Creates a default router module and a root component.

  #### Example Usage

  ```console
  $ mix tamnoon.override_root

  Successfully created "lib/router.ex"!
  Successfully created "lib/components/root.ex"!
  Done! Now add router: MyApp.Router to your Tamnoon options in `application.ex` as
  such:

          def start(_type, _args) do
            children = [
              {Tamnoon, [[router: MyApp.Router]]}
            ]
            opts = [strategy: :one_for_one, name: MyApp.Supervisor]
            Supervisor.start_link(children, opts)
          end
  ```
  """
  @shortdoc "Creates a default router module and a root component"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    if !File.dir?("lib/components") do
      if Mix.shell().yes?(
           "Directory \"lib/components\" does not exist, do you want to run `mix tamnoon.make_dirs` to create it?",
           default: :yes
         ) do
        Mix.Task.run("tamnoon.make_dirs")
        Mix.Task.run("tamnoon.override_root")
      end
    else
      app_name = Mix.Project.config()[:app] |> Atom.to_string() |> Macro.camelize()

      if File.exists?("lib/router.ex") do
        Mix.shell().info("File \"lib/router.ex\" already exists, skipping..")
      else
        File.write!("lib/router.ex", """
        defmodule #{app_name}.Router do
          @moduledoc \"\"\"
          This module provides a default router for HTTP(S) requests, which builds and serves the web app.
          \"\"\"

          use Plug.Router

          plug(Plug.Static,
            at: "/tamnoon",
            from: :tamnoon,
            gzip: false
          )

          plug :match
          plug :dispatch

          get "/" do
            Tamnoon.LiveReload.try_recompile()
            Tamnoon.Compiler.build_from_root(#{app_name}.Components.Root)
            send_file(conn, 200, "tamnoon_out/app.html")
          end

          match _ do
            send_resp(conn, 404, "404")
          end
        end
        """)

        Mix.shell().info("Successfully created \"lib/router.ex\"!")
      end

      if File.exists?("lib/components/root.ex") do
        Mix.shell().info("File \"lib/components/root.ex\" already exists, skipping..")
      else
        File.write!("lib/components/root.ex", """
        defmodule #{app_name}.Components.Root do
          @behaviour Tamnoon.Component

          @impl true
          def heex do
            ~s\"\"\"
            <!DOCTYPE html>
            <html lang="en">

              <head>
                <meta name="description" content="Webpage description goes here" />
                <meta charset="utf-8">
                <title>Tamnoon App</title>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <script src="tamnoon/tamnoon_dom.js"></script>
                <script src="tamnoon/tamnoon_driver.js"></script>
                <link rel="icon" type="image/x-icon" href="/tamnoon/tamnoon_icon.ico">
              </head>

              <body>
                  <h1>Welcome to your Tamnoon app!</h1>
              </body>
            </html>
            \"\"\"
          end
        end
        """)

        Mix.shell().info("Successfully created \"lib/components/root.ex\"!")
      end

      Mix.shell().info(
        "Done! Now add router: #{app_name}.Router to your Tamnoon options in `application.ex` as such:

          def start(_type, _args) do
            children = [
              {Tamnoon, [[router: #{app_name}.Router]]}
            ]
            opts = [strategy: :one_for_one, name: TamnoonTest.Supervisor]
            Supervisor.start_link(children, opts)
          end"
      )
    end
  end
end
