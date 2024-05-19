# PubSub

This guide assumes that you have been following the previous guides. You can follow along if you haven't too, however you may want to either skim over the previous ones or take a look at the [sample app's source](https://github.com/omer-sm/tamnoon_sample).

## Channels

Tamnoon's PubSub functionality relies on _channels_. By default, every new client is added to the `"clients"` channel. Channels can be subscribed to, unsubscribed to, and published to. 

## Subscribing and Unsubscribing

By utilizing the `"sub"` and `"unsub"` methods (see `m:Tamnoon.Methods`), clients can subscribe and unsubscribe to channels. A client that is subscribed to a channel will execute any action that is _published_ to that channel.

_Note: unlike the state, channels are dynamically created. This means that when subscribing to a channel that does not exist, it will be created._

## Publishing

By _publishing_ to a channel, a client will cause any subscriber of that channel to execute the action requested. For example:

```
{
    "method": "pub",
    "channel": "clients",
    "action": {
        "method": "update",
        "key": "val",
        "val": 1
    }
}
```

The above request will cause every client (as it is published to the `"clients"` channel) to update the value of `"val"` to 1. This will trigger a message from the server to the client specifying the new value, as with simply using the `"update"` method.

## Synchronizing Our Clients

Now, let's say we utilized our `"nudge"` method from the previous guide and made buttons to increment / decrement the number. Currently, the button to increment will send the following JSON:

```
{
    "method": "nudge",
    "key": "val",
    "direction": "up"
}
```

To make it change the number of _every_ client, we can simply wrap it in a `"pub"`:

```
{
    "method": "pub",
    "channel": "clients",
    "action": {
        "method": "nudge",
        "key": "val",
        "direction": "up"
    }
}
```

Now we can open two clients and see it in action. We can nudge the value up and down, and it updates automatically. However, if we change the number before opening another client, the numbers themselves won't be the same - they will just change at the same time. This can be solved, for example, by using an agent to hold a global value, or by 
making a custom method that will cause other clients to publish an `"update"` action with their value. However, this is enough for now.

Soooo... that's it! Pretty simple right? You are now ready to start making real-time web apps with Elixir and your favorite front-end technology. Go wild!
