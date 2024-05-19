# Basic Usage

With Tamnoon aiming to be as simple as possible, you don't need much more than the basic functionality in order to write simple apps. We will be creating a simple app where users can fight a number that is displayed.

First, you can set up your _initial state_ by passing a map of the default configuration to the, aptly named, `:initial_state` property of Tamnoon in your `start/2` function:

```
children = [
  {Tamnoon, [[initial_state: %{val: 0}]]}
  #...
]
```

This will configure Tamnoon to give a default state with a field `:val` of value 0 to every new client. Note that Tamnoon does not support dynamic states - meaning, our state will only ever have one field - `:val`. 

Believe it or not, that is basically it for the backend. However we still have no front-end! Usually you can serve your front-end separately, but for this tutorial we will serve it from our app by creating a custom router.

Create a new file named `router.ex` in your _lib_ directory, and set it as such:
```
defmodule TamnoonSample.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_file(conn, 200, "priv/static/index.html")
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
```

The router will now serve the file `index.html` file at `priv/static` - so we need to create the directories and the file. Additionally, we need to tell Tamnoon to use our router instead of the default one. In your `start/2` function, update Tamnoon as such:

```
children = [
  {Tamnoon, [[initial_state: %{val: 0}, router: TamnoonSample.Router]]}
]
```

Now let's create the html file. We won't go over it here, however you can look at the source code on github. What _is_ important however is the JSON of the requests we will be sending. We want to have our app show the value of `:val` in our state. This can be achieved by sending the following request to our server:

```
{
    "method": "get",
    "key": "val"
}
```

This (and the `"update"` method) returns a map of `%{key: value}` to the client. As such, we need to set an appropriate handler for this in our html file.

Now, we can move on to defining methods for incrementing or decrementing our number.