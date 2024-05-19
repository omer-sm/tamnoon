# Method Overview

This guide is a simple collection of examples for the JSON requests the default methods accept and the JS objects they return. (see `m:Tamnoon.Methods`)

### get

```
{
    "method": "get",
    "key": "your key"
}
```
_Returns: {key: value} or {error: "Error: no matching key"}_

### update

```
{
    "method": "update",
    "key": "your key",
    "val": "your new value"
}
```
_Returns: {key: value} or {error: "Error: no matching key"}_

### sub

```
{
    "method": "sub",
    "channel": "your channel"
}
```
_Returns: {sub: :ok}_

### unsub

```
{
    "method": "unsub",
    "channel": "your channel"
}
```
_Returns: {unsub: :ok} or {error: "Error: can't unsub from clients channel"}_

### pub

```
{
    "method": "pub",
    "channel": "your channel",
    "action": {
        "method": "any method",
        ...
    }
}
```
_Returns: {pub: :ok}_

### subbed_channels

```
{
    "method": "subbed_channels"
}
```
_Returns: {subbed\_channels: channels\_array}_

