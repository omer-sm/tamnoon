# Getting Started

Getting started with Tamnoon takes only a few simple steps. First, create a new project with a supervision tree:

```console
$ mix new [NAME] --sup
```

Then, add Tamnoon to your `deps` in `mix.exs`:

```
  defp deps do
    [
      # Other dependencies...
      {:tamnoon, "~> 0.1.0"}
    ]
  end
```

We can now get started! Simply add Tamnoon to your supervision tree as such:

```
  def start(_type, _args) do
    children = [
      {Tamnoon}
    ]
    opts = [strategy: :one_for_one, name: TamnoonTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
```

You can now run your project by using `iex -S mix` and bask in the glory of your work:

```console
11:01:54.386 [info] Tamnoon listening on port 4000..
```

...Or you can keep reading the documentation to actually be able to make something useful. Up to you :)