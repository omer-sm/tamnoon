# Tamnoon HEEx

Tamnoon HEEx is an extension of HEEx (HTML + Elixir), which makes it easy to add real-time functionality.

## Reading Variables

When we want to read a variable from the state in our app (in this example we will display the user's name), we can simply include it as `@variable` in a component as such:

```
<p hidden=@hidep> can you see me? </p>
<p>@name</p>
<p>@raw-name</p>
```

- The first _<p>_ will be hidden if we have a method that returns `%{hidep: true}` to the client. We don't need to have a variable named _hidep_ in our state for that work, however most often you will want to.

- The second _<p>_ will have its text updated every time the _name_ variable changes. 

- The last _<p>_ will have its inner _HTML_ updated every time _name_ changes. This is a way to dynamically switch between components.

## Updating Variables (Events)

Now let's update our variables. Consider the following:

```
<button onclick=@log>push me!</button>
<input onchange=@update-name />
```

- As seen previously, the button will trigger the `log` method when pressed.

- The input will trigger the `update` method for the key _name_. 

These are _events_. By default, events send the server an object with fields for the method, the outer HTML of the element, the value of it, and if a _-_ is used then also a key. _(There is additional syntax for using `pub`, we will go over it in the PubSub guide)_

## Example

Let's continue our chat room. Inside `"app.html.heex"` add the following:

```
<p>Name: <span>@name</span> </p>
<input oninput=@update-name />
```

Restart the server, reload the page, and you should now see the name change as you type!