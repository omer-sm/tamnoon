# V1 (Fullstack) Guide

> #### Note {: .info}
> This guide still is WIP and is __temporary__! It is likely that many things will be 
> very brief and not explained fully. I am planning to revise the whole documentation in
> the V1 release.

This guide will help you make a fullstack app (specifically the front-end part) using Tamnoon.

## Components

In Tamnoon, the webpage is comprised of several Tamnoon HEEx components. To define a component, make either a module that implements the `m:Tamnoon.Component` behaviour, or a HEEx file (a file ending with .html.heex) in the _lib/components_ directory. 

To use a component inside of another component, you can use the following syntax (where _component_ is either a component module or the file name of a HEEx file component):

```
<%= r.([component]) %>
```

See `Tamnoon.Compiler.render_component_dyn/1` for more info.

Note that EEx blocks inside components are _static_, meaning that from when the component is rendered on the page, they don't change. To make components that can dynamically change (such as a list of components), you should make a variable that contains the component and set it to the inner HTML of a div (for example). See the following section for more info on how to do that.

## Tamnoon HEEx

Tamnoon HEEx is an extension of HEEx that adds support for listening to and triggering Tamnoon events. Any valid HEEx code is valid Tamnoon HEEx code. 
To listen to an event, assign some HTML attribute (or the inner HTML) of an element to @ and a variable name. That is, if you want a _<p>_ tag to display the value of a variable named "myvar", and be hidden when a variable named "hidep" is true, you would write it as such:

```
<p hidden=@hidep>@myvar</p>
```

Any time the server sends a map with a key named "myvar", the inner text (or the inner HTML if _myvar_ is prefixed with _raw-_) of the _<p>_ will update to display it. Same goes for "hidep". Note that the attributes set to a Tamnoon variable get removed from it in the final HTML, so you can set default values like so:

```
<p hidden=@hidep hidden="true">@myvar</p>
```

To emit events, define an element with an event listener (such as "onclick") and set it to the name of a Tamnoon method you have defined. When that event fires, the server will receive a message containing the following keys: "val" containing the value of the element, and "element" containing the outer HTML of the element. This is how you would define a text input that triggers a method named `setval` when it changes:

```
<input oninput=@setval />
```

You can also trigger methods with different keys without making a new one for each with the _implicit events_ syntax. For example, the following will trigger the `update` method for the key `myval`: _(note that a field with the key `"val"` will be added as with any input event)_

```
<input oninput=@update-myval />
```

The `"pub"` method can also be triggered like this, with the following syntax: `@pub-[channel]-[method]-[key (optional)]`

## Making the app component

By default, the _root_ layout embeds in itself a component in a file named "app.html.heex". To make your web app, create a _components_ directory inside _lib_, and write your Tamnoon HEEx code in it. For example:

```
<p>1 + 1 = <%= 1 + 1 %></p>
<p>@val</p>
<input oninput=@setval />
<%= r.(["mycomponent.html.heex, %{assigned_variable: "Hello, World!"}]) %>
```

Add a `:val` variable and a `:setval` Tamnoon method to set the value of val. You should now be able to see val update dynamically as you type.

Make a component named "mycomponent.html.heex" and see how it is shown on the page as well. You can also use the @assigned_variable inside EEx blocks in it!