# PubSub

**PubSub** (Publish-Subscribe) is a messaging pattern where clients _publish_ messages to _channels_, and other clients _subscribed_ to those channels receive and react to the messages in real time. Tamnoon provides built-in _PubSub_ functionality, enabling communication between multiple clients.

In Tamnoon's case:

- Clients publish _method calls_ to _channels_.

- Other clients _subscribed_ to those _channels_ will receive and execute the _method calls_.

- Clients can _subscribe_ and _unsubscribe_ from _channels_ dynamically.

This allows for real-time interaction between clients - ideal for collaborative apps, chat rooms, live dashboards, and more.

#### Example

If a client publishes an `:add_message` method to the channel `"room_123"`, all clients subscribed to `"room_123"` will receive and execute the `:add_message` method.

## Channels

When publishing method calls, they are sent to a specific _channel_. Clients can dynamically _join_ or _leave_ channels using the built-in `:sub` and `:unsub` methods, and view their current subscribed channels using `Tamnoon.Methods.subbed_channels/0`.

- `:sub` subscribes the client to a channel.

- `:unsub` unsubscribes the client from a channel.

- Both methods expect a channel name passed in as `req["channel"]`.

Channels are automatically created when a client attempts to subscribe to one that doesn't exist.

> #### The clients channel {: .info}
>
> All clients are automatically subscribed to a special channel named `"clients"`. This channel is non-leavable.

#### Example

```
defmethod :switch_room do
  target_room_id = req["value"]

  Tamnoon.Methods.unsub(%{"channel" => "room_\#{state[:current_room_id]}"}, state)
  Tamnoon.Methods.sub(%{"channel" => "room_\#{target_room_id}"}, state)

  {%{current_room_id: target_room_id}}
end
```

In the example above:

- The client leaves their current room channel (e.g., `"room_1"`).

- Then joins the new room channel (e.g., `"room_2"`).

- The client's state is updated to reflect the new `current_room_id`.

## Publishing

In Tamnoon, clients communicate with each other by _publishing_ method calls. These calls are broadcast to a specified _channel_, where all clients _subscribed_ to that channel (including the sender) will receive and execute the method as if they triggered it themselves.

To publish a method call, use the built-in _:pub_ method, which accepts:

- `"channel"` - the name of the channel to publish to.

- `"action"` - a map containing:

  - `"method"` - the method name to call.

  - Any additional data to pass along via req.

#### Example

```
defmethod :send_message do
  %{
    current_message: current_message,
    current_room_id: current_room_id
  } = state

  Tamnoon.Methods.pub(%{
    "channel" => "room_#{current_room_id}",
    "action" => %{
      "method" => "add_message",
      "message" => current_message
    }
  }, state)

  {%{current_message: ""}}
end
```

**What this does:**

- Publishes a call to the `:add_message` method on the channel for the current room.

  - All clients in that room (including the sender) will receive and run `:add_message`.

  - The message content is sent as `req["message"]`.

- Clears the `:current_message` state field on the sender's side only (clean-up).

> **This is a common pattern in Tamnoon:**
>
> - One method (e.g., `:send_message`) handles logic _only the publisher_ needs (validation, cleanup, etc.).
>
> - It then _publishes_ another method (e.g., `:add_message`) that contains logic for _all clients_ in the channel.
