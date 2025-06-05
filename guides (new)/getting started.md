# Getting Started

To get started with Tamnoon, make a new app with a supervision tree:

```console
$ mix new [NAME] --sup
```

Then, add Tamnoon to your `deps` in `mix.exs`:

```
  defp deps do
    [
      # Other dependencies...
      {:tamnoon, "~> 1.0.0-a.4"}
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

You should now be able to run `mix run --no-halt` and get the following message in your console:

```console
10:34:54.305 [info] Tamnoon listening on http://localhost:8000..
```

If everything went correctly, you should a blank page when visiting http://localhost:8000 on your browser. The next guide will go over the basic workflow with Tamnoon.