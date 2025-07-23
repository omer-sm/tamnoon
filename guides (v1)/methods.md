# Methods

This guide will cover _methods_ - the main way to add interactions to your app. Methods are functions that are used to change your app's _state_.

## The state

A Tamnoon app maintains a _state_ for each client - a map of key-value pairs that can be read and updated in response to user interactions. This state is initialized as part of your Tamnoon options:

```
def start(_type, _args) do
  children = [
    {Tamnoon, [[
      initial_state: %{
        message: "Hello World!",
        button_hidden: true,
        username: "user"
      },
      # Other options...
    ]]}
  ]
  ...
end
```

> _Note: State keys must be atoms - not strings._

To interact with the application state, you'll need to use _Tamnoon HEEx_, which is covered in the next guide.

## Methods

Methods are Elixir functions triggered by user interactions in the UI. They allow you to perform logic and update the application state. Methods are defined using the `Tamnoon.MethodManager.defmethod/2` macro inside designated methods modules.

#### Defining a methods module

To define a methods module, create a new Elixir module - typically placed under `lib/methods/` - and register it in your Tamnoon options:

```
def start(_type, _args) do
  children = [
    {Tamnoon, [[
      methods_modules: [
        MyApp.Methods.MyMethodsModule
      ]
      # Other options...
    ]]}
  ]
  ...
end
```

#### Defining a method

Inside your methods module, import `m:Tamnoon.MethodManager` and use the `Tamnoon.MethodManager.defmethod/2` macro to define methods:

```
defmodule MyApp.Methods.MyMethodsModule do
  import Tamnoon.MethodManager

  defmethod :ping do
    IO.inspect("pong")

    {%{}}
  end
end
```

In this example:

- `:ping` is the name of the method.

- The method prints `"pong"` to the console.

- It returns a tuple `{diffs}`, where `diffs` is a map of state changes.

### Method parameters

The `Tamnoon.MethodManager.defmethod/2` macro provides your method with two arguments:

1. `state`: The current application state as a map.

2. `req`: A map containing metadata about the method invocation:
   - `:value`: The _value_ of the element that triggered the method.
   - `:key`: A custom key provided when invoking the method (optional, only included if one is provided).
   - `:element`: The raw HTML string of the invoking element.

### Method return values

A method must return one of the following:

- A single-element tuple `{diffs}`.

- A two-element tuple `{diffs, actions}`.

- A three-element tuple `{diffs, actions, new_state}`.

> The second element, `actions`, will be explained in the Actions guide.

- `diffs`: A map of state changes that will be sent to the client.

- `new_state`: The updated full state after the method is executed. If not provided, `diffs` will be merged into the state automatically.

#### Example

The snippet below is a full example of a methods module containing a method `:increment` which increments a `:counter` value:

```
defmodule MyApp.Methods.CounterMethods do
  import Tamnoon.MethodManager

  defmethod :increment do
    current_count = Map.get(state, :counter)

    {%{counter: current_count + 1}}
  end
end
```

### Calling methods from other methods

Tamnoon allows you to call one method from another, which is useful for composing logic and avoiding duplication.

There are two main ways to do this:

1. **Manual invocation**

You can directly invoke a method from within another by calling the underlying function it defines.

- Built-in methods can be called using `Tamnoon.Methods.<function_name>`.

- Custom methods defined using `Tamnoon.MethodManager.defmethod/2` are available as regular functions with the prefix `tmnn_` in the defining module.

The result of the invoked method must be manually handled and returned from the calling method.

#### Example

In the example below, triggering the `:ping_and_color` method will update the `:message` to `"pong"` and set its color to `"green"`:

```
defmethod :ping do
  {%{message: "pong"}}
end

defmethod :ping_and_color do
  {%{message: message}} = tmnn_ping(%{}, state)

  {%{message_color: "green", message: message}}
end
```

Here:

`tmnn_ping/2` is called with an empty `req` and the current `state`.

Its result is destructured and merged with additional changes before returning.


2. **Using `trigger_method/3`**

Tamnoon also provides the `Tamnoon.MethodManager.trigger_method/3` function, which allows you to invoke a method by name from within another method.

```
trigger_method(method_name :: atom, req :: map, timeout_ms :: integer)
```

- `method_name` - The name of the method to trigger (as an atom).

- `req` - A map that will be passed as the method’s req argument.

- `timeout_ms` - (Optional) Time in milliseconds before the method runs. Omit or use 0 for immediate execution.


#### Key Difference

Unlike manual invocation, `trigger_method/3` automatically sends the result of the called method to the client. This means you don't need to merge or return the result yourself - the response is handled for you.


#### Example

```
defmethod :ping do
  {%{message: "pong"}}
end

defmethod :ping_and_color do
  Tamnoon.MethodManager.trigger_method(:ping, %{}, 1000)

  {%{message_color: "green"}}
end
```

In this example:

- When `:ping_and_color` is triggered, the `:message_color` is immediately updated to `"green"`.

- After 1 second, the `:ping` method is triggered, updating the `:message` to `"pong"`.

This is especially useful for delayed interactions, animations, or chaining state updates over time.


## Built-in methods

Tamnoon provides a collection of built-in methods for you to use.

### 