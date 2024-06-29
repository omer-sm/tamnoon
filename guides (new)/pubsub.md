# PubSub

Tamnoon comes with built-in _PubSub_ functionality, allowing you to sync up multiple clients easily. 

## Channels

A _channel_ is a collection of clients that can be subscribed to and unsubscribed from. By default, every client is subscribed to the _"clients"_ channel. When a client publishes an _action_ to a channel, every client in that channel will handle it as if it was any other request. To interact with channels, you may use the _sub_ (`Tamnoon.Methods.tmnn_sub/2`), _unsub_ (`Tamnoon.Methods.tmnn_unsub/2`), and _subbed\_channels_ (`Tamnoon.Methods.tmnn_subbed_channels/2`) methods. This is how you would create buttons to subscribe and unsubscribe to a channel using Tamnoon HEEx:

```
<button onclick=@sub-my_channel>sub</button>
<button onclick=@unsub-my_channel>unsub</button>
```

## Publishing

To utilize PubSub, we need to use the _pub_ (`Tamnoon.Methods.tmnn_pub/2`) method. To trigger it via Tamnoon HEEx, we may use the following syntax: `@pub-channel-method-key` (or without the _-key_ part if a key is not required). For example, this input will update the name of _every_ client when it changes:

```
<input oninput=@pub-clients-update-name />
```

You may add it to your `"app.html.heex"` and see how it works when you open the page in two different tabs.

And that's it! You are now familiar with every functionality Tamnoon has to offer. You may continue reading the next guide, which will finish the actual chat room - however, that is completely optional.