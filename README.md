# Tamnoon

#### Make Elixir power your favorite front-end framework effortlessly!

This package/framework is designed to serve as a simple replacement for those big scary frameworks that have a huge learning curve and are waaaaaay (like, waaaaaay) too overkill for simple web apps.

By utilizing websockets, Tamnoon can provide realtime client-server communication and PubSub functionality (in fact, it comes with this ability out of the box!) without a need to worry about anything.

And the best part? It doesn't even matter which front-end technology you want to use. Hell, as long as it can send json over websockets, it doesn't even have to be a web app! Could be a turtle for all I care. _(if you somehow find a turtle that can communicate via websockets, that is..)_

## Installation

The package can be installed by adding `tamnoon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tamnoon, "~> 0.1.0"}
  ]
end
```

The docs can be found at <https://hexdocs.pm/tamnoon>.

