# Wrapping Up

In this "guide", we will utilize the different features to create a chat app, continuing from the previous guides. The source code for the result is available on [github](https://github.com/omer-sm/tamnoon_chatroom).

First of all, let's delete everything in our `"app.html.heex"` and start from fresh. Now, add inputs for the user's name and the message:

```
<h4>Name: <span> @name </span> </h4>
<input onchange=@update-name />
<br>
<input oninput=@update-curr_msg value=@curr_msg />
<button onclick=@send_msg>></button>
```

The topmost input will change the user's name every time it changes, and those changes will be reflected in the h4 above it. Currently the other input and the button don't really do anything, so let's change that by adding a _send\_msg_ method in our _methods module_:

```
  defmethod :send_msg do
    {msg, new_state} = Map.get_and_update(state, :curr_msg, &({&1, ""}))
    msg = Tamnoon.Compiler.render_component(TamnoonChatroom.Components.MessageBox, %{
      user_name: state[:name],
      content: msg
    }, true)
    {%{pub: :ok}, new_state} = pub(%{
      "channel" => "clients",
      "action" =>
      %{"method" => "add_msg",
        "msg" => msg}
    }, new_state)
    {%{"curr_msg" => ""}, new_state}
  end
```

This will clear the value of the _"curr\_msg"_ input, and _pub_ a request of the _add\_msg_ method. Let's define that method as well:

```
  defmethod :add_msg do
    msg = req["msg"]
    {_old_msgs, new_state} = Map.get_and_update(state, :msgs, &({&1, [msg | Enum.take(&1, 4)]}))
    msgs_ret = Enum.reduce(new_state[:msgs], fn x, acc ->
      x <> acc
    end)
    {%{"msgs" => msgs_ret}, new_state}
  end
```

This will add the new message to _"msgs"_, make sure there are 5 messages at most, and return all the messages as snippet of HTML code to the client. To display our messages, we simply add a _<div>_ with `@raw-msgs` as its inner value to `"app.html.heex"`. This will display the content of _"msgs"_ as HTML. Now, `"app.html.heex"` looks like this:

```
<h4>Name: <span> @name </span> </h4>
<input onchange=@update-name />
<br>
<div> @raw-msgs </div>
<br>
<input oninput=@update-curr_msg value=@curr_msg />
<button onclick=@send_msg>></button>
```

All that is left is to restart the server, reload the page, and we now have a functioning chat!

![Final Chat App Preview](assets/chat.gif)

