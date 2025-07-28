# Tamnoon HEEx

Tamnoon HEEx extends standard HTML + EEx by introducing _reactivity_ and _interactivity_. It allows your UI to respond to events and manipulate the application’s _state_ directly from components.

## Reading From the State

Within components, you can access state values using the `@` symbol. Tamnoon HEEx allows you to inject these values directly into your markup. Here are some examples:

```xml
<p>@message</p>
<!-- Renders: <p>Hello World!</p> -->

<button hidden=@button_hidden>Can you see me?</button>
<!-- Renders a hidden button if @button_hidden is true -->

<p>Welcome back, <span>@username</span>!</p>
<!-- Renders: <p>Welcome back, user!</p> -->
```

### Negation

You can prefix any state value with `not-` in order to negate its boolean value. This is especially useful for toggling visibility, disabling elements, or applying conditional logic in your UI.

#### Example

```xml
<button hidden=@not-show_button>Can you see me?</button>
```

In the example above:

- When `:show_button` is `true`, `@not-show_button` becomes `false`, and the button is **shown**.

- When `:show_button` is `false`, `@not-show_button` becomes `true`, and the button is **hidden**.

### Injecting HTML

By default, state values are HTML-escaped to prevent injection vulnerabilities. However, if you intentionally want to render raw HTML from your state, you can opt in by prefixing the key with `raw-`. For example:

```html
<div>@raw-my_unescaped_html</div>
```

This will render any HTML code that `:my_unescaped_html` contains.

_Warning: use this feature with caution to avoid introducing security risks such as XSS (cross-site scripting)._

> #### Mixing state values with static text {: .warning}
>
> When used as an element's content, state values must be used as its entire content. They cannot be mixed directly with static text.
> To combine dynamic values with static content, wrap the dynamic part in an inline element such as `<span>` - see the third example above.

## Interacting With the State

Tamnoon HEEx allows you to trigger _methods_ directly from user interactions with components. This functionality comes in several main forms:

#### 1. Simple Trigger

By setting an element's event handler (such as `onclick`, `onchange`, etc.) to a method name prefixed with `@`, the method will be invoked when the event fires. For example:

```xml
<button onclick=@ping>Ping!</button>
```

Clicking the button will invoke the `:ping` method.

#### 2. Triggering With Arguments

You can also pass arguments to methods directly from the element. This can be done in two ways:

a. **Passing a key**

A _key_ can be passed by appending it with a dash to the method name:

```xml
<input onchange=@update-name placeholder="Enter your name.." />
```

This will invoke the `:update` method with the key `"name"`, available as `req["key"]` in the method.

_Note: For the `:sub` and `:unsub` methods, the key will be passed as `"channel"`._

b. **Passing a value**

If the triggering element has a `value` attribute (e.g., input elements or buttons with a manually set value), the value will be available as `req["value"]`. For example:

```xml
<button onclick=@update-theme value="dark">Dark mode</button>
```

Clicking the button will trigger the `:update` method with `"theme"` as the key and the `"dark"` as the value.

#### 3. Triggering a Publish

The `:pub` method can be triggered from Tamnoon HEEx by using the special `@pub` syntax:

```
@pub-<channel>-<method>-<key>
```

- `<channel>`: The name of the channel to publish to.

- `<method>`: The method to invoke on all clients in that channel.

- `<key>` (optional): A key to pass along with the method call.

#### Example

The following button will broadcast the `:ping` method to all clients in the `"clients"` channel when clicked:

```xml
<button onclick=@pub-clients-ping>Ping everyone!</button>
```

This is equivalent to calling the `:pub` method in a method with:

```
Tamnoon.Methods.pub(%{
  "channel" => "clients",
  "action" => %{"method" => "ping"}
}, state)
```

> #### Multiple triggers in an element {: .info}
>
> An element can have multiple event handlers for the same event in Tamnoon, and all of them will be triggered when the event fires.
> However, this is usually not recommended and can often be replaced with a cleaner, combined handler.
>
> #### Example
>
> `<button onclick=@first_method onclick=@second_method>Activate both methods!</button>`