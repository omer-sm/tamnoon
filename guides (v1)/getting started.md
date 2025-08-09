# Getting Started

To begin using Tamnoon, create a new Elixir project with a supervision tree:

```console
$ mix new [NAME] --sup
```

Next, add Tamnoon to your `deps` in `mix.exs`:

```
  defp deps do
    [
      # Other dependencies...
      {:tamnoon, "~> 1.0.0-rc.2"}
    ]
  end
```

Then, run the setup command to initialize the project:

```console
$ mix tamnoon.setup
```

This command will guide you to update your application’s start_link function to include Tamnoon. Follow the instructions provided in the terminal, and your project will be ready to go.


### What Just Happened?

The `mix tamnoon.setup` command adds a few essential files and directories to your project structure. Here's what each one is for:

- _tamnoon\_out/_ - A directory that contains the compiled HTML file to be served to the client.

- _lib/components/_ - The directory where your app's components are defined.

- _lib/components/root.ex_ - The root component of your application, serving as the entry point for your UI.

- _lib/router.ex_ - A Plug.Router module that handles serving static files for your Tamnoon app.


## Running The App

Once the setup is complete, you can start your application using the following command:

```console
$ mix run --no-halt
```

If everything is set up correctly, you should see the following output in your terminal:

```console
10:34:54.305 [info] Tamnoon listening on http://localhost:8000..
```

At this point, your app is up and running. You can now proceed to the **Components** guide to begin building your interface.