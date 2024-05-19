# Custom Methods

Assuming that you've been following the _basic usage_ tutorial, you should have created a basic Tamnoon app that stores a value. Now, what about changing the value?

We could use the `"update"` method to do that and set it to something specific. For example, sending the following request to the server will set the value to 1:

```
{
    "method": "update",
    "key": "val",
    "val": 1
}
```

However, that is really fucking boring. We're here for fun. How about we use the `Tamnoon.MethodManager.defmethod/2` macro to create a _custom method_ instead?

We'll start off by making a file called `methods.ex` and having it `use Tamnoon.Methods`. This will set our module up to support every built-in method and let us define additional ones. (see `m:Tamnoon.Methods`)

We will now utilize the `Tamnoon.MethodManager.defmethod/2` macro to create a _custom method_ called `"nudge"`. This method will take a key and a direction (up/down) and increment / decrement the value of the field. For example, this will increment `"val"` by 1.

```
{
    "method": "nudge",
    "key": "val",
    "direction": "up"
}
```

Now, let's define our method handler in our `methods.ex` file as following:

```
  defmethod :nudge do
    key = Tamnoon.Methods.get_key(req, state)
    val = Map.get(state, key)
    new_val = if (req["direction"] == "up"), do: val + 1, else: val - 1
    new_state = Map.put(state, key, new_val)
    {%{key => new_val}, new_state}
  end
```

This will simply change the value of the request field by 1. We can now test it, and see that it works. However, we want to have our users "fight" over the number - and currently that is not happening. If you open two clients at the same time, you will see that each one has their own value, independent of the other. 

For the value to be shared, we will need to utilize _PubSub_ functionality, which we will go over in the next tutorial.