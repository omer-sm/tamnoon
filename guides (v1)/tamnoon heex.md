# Tamnoon HEEx

Tamnoon HEEx extends standard HTML + EEx by introducing _reactivity_ and _interactivity_. It allows your UI to respond to events and manipulate the application’s _state_ directly from components.


## Reading from the state

Within components, you can access state values using the `@` symbol. Tamnoon HEEx allows you to inject these values directly into your markup. Here are some examples:

```
<p>@message</p>
<!-- Renders: <p>Hello World!</p> -->

<button hidden=@button_hidden>Can you see me?</button>
<!-- Renders a hidden button if @button_hidden is true -->

<p>Welcome back, <span>@username</span>!</p>
<!-- Renders: <p>Welcome back, user!</p> -->
```

> #### Mixing state values with static text {: .warning}
> When used as an element's content, state values must be used as its entire. They cannot be mixed directly with static text.
> To combine dynamic values with static content, wrap the dynamic part in an inline element such as `<span>` - see the third example above.


## Interacting with the state

Tamnoon HEEx also gives you the ability to trigger _methods_ directly from component interactions.