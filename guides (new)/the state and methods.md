# The State and Methods

## The State

In Tamnoon, every app keeps a _state_. The state is a map consisting of multiple _variables_, which can be read and changed by the app. It can be thought of similarly to an agent.
To set the initial state, change Tamnoon's `child_spec` in your supervision tree as such:

```
{Tamnoon, [[initial_state: %{msgs: [], name: "", curr_msg: ""}]}
```

As you can see, we are storing the user's name, the message the user is currently typing, and the messages.

_Note: The state should not have string keys, only atoms._

## Methods

When we want something to happen, we need to trigger _methods_. Methods are the client's way of interacting with the server. Tamnoon comes with a few different built-in methods for interacting with the state and for implementing PubSub functionality (more on that later):

- `get`: Returns the value of the requested variable to the client.

- `update`: Sets the value of the requested variable to the the value specified in the request, and returns the new value to the client.

- `sync`: Returns all of the state to the client.

- `sub` and `unsub`: Subscribe and unsubscribe the client from the requested channel. 

- `pub`: Sends the request under the "action" field to all the other clients in the requested channel.

- `subbed_channels`: Returns a list of the channels the client is currently subscribed to.

**Tamnoon abstracts this whole process, so you don't need to worry about it.** However, FYI: methods are triggered by the client sending a json object to the server. The `update` and `get` methods both expect a field with the key `"key"`, which is a name of a variable in the state. `update` also expects a field with the key `"val"` which is the new value of the variable.

## Custom Methods

You may also create additional methods if you wish. To do so, you need to make a _methods module_. Make a file named "methods.ex" inside "lib", and add the following content to it:

```
defmodule TamnoonChatroom.Methods do
  use Tamnoon.Methods

  defmethod :log do
    IO.inspect(req)
    IO.inspect(state)
    {nil, state}
  end
end
```

Here we are utilizing the `Tamnoon.MethodManager.defmethod/2` macro, imported by the `use Tamnoon.Methods` line. A method can access the `state` and `req` variables, and needs to return a tuple containing the value to return to the client (usually a map) and the updated state.

Before we can test it, we need to set the module as our _methods module_. Inside your _application.ex_, change the `start` function as such:

```
def start(_type, _args) do
    children = [
      {Tamnoon, [[initial_state: %{msgs: [], name: "", curr_msg: ""},
      methods_module: TamnoonChatroom.Methods]]}
    ]
    # ...
  end
end
```

To test it, let's create a button to trigger the method. add the following to your `"app.html.heex"` file:

```
<button onclick=@log>push me!</button>
```

For now, don't worry about the _onclick=@log_ part. That is Tamnoon HEEx, which we will go over in the next guide. Once you restart the server and reload the page, you should see the following output on your console:

```
%{
  "element" => "<button class=\" tmnnevent-onclick-log\">push me!</button>",
  "method" => "log",
  "val" => ""
}
%{name: "", msgs: [], curr_msg: ""}
```

We can now move on to Tamnoon HEEx, which will allow you to interact with the server in real-time.