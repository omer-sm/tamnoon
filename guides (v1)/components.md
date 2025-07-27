# Components

In Tamnoon, the user interface is built using _components_ - reusable building blocks written in Tamnoon HEEx, Tamnoon's templating language.
Tamnoon HEEx is an extension of HEEx (HTML + Elixir), with additional features tailored specifically for Tamnoon, which will be covered in the Tamnoon HEEx guide.

In practice, components can be created in one of two ways:

1. Elixir modules that implement the `m:Tamnoon.Component` behaviour:

```
defmodule MyApp.Components.MyComponent do
  @behaviour Tamnoon.Component

  @impl true
  def heex do
    ~s"""
    <h1>Hello World!</h1>
    """
  end
end
```

2. `.html.heex` files containing Tamnoon HEEx markup directly:

```html
<h1>Hello World!</h1>
```

## Injecting Code Into Components

While components can be written as plain HTML, you'll often need to introduce dynamic behavior. This is where EEx (Embedded Elixir) comes into play.

Tamnoon HEEx supports standard EEx syntax, allowing you to embed Elixir code directly within your components using `<% %>` and `<%= %>` tags:

- `<%= %>` evaluates and renders the result.

- `<% %>` evaluates the code but does not render any output.

#### Example

```html
<% time = Time.utc_now() %>
<p>
  <%= if Time.before?(time, ~T[12:00:00]), do: "Good morning", else: "Good
  day"%> world!
</p>
```

This will render either _Good morning world!_ or _Good day world!_ depending on the current time.
Note that this code runs once when the component is rendered, not on every DOM update.

> #### The h.() helper {: .info}
>
> Inside EEx tags in components, you can use the `h.()`helper function, which will escape any HTML inside a string (see `Tamnoon.Compiler.escape_html/1`).

## Rendering Other Components

Tamnoon allows you to render components from within another using the `r.()` helper, which internally calls `Tamnoon.Compiler.render_component_dyn/1`.

You can use this syntax inside Tamnoon HEEx templates:

```html
<%= r.(MyApp.Components.MyComponent) %> <%= r.("my_component.html.heex") %>
```

Both forms will inject the output of the specified component into the current one:

- The first renders a component defined as an Elixir module.

- The second renders a component defined in a `.html.heex` file.

This makes it easy to compose complex UIs from smaller, reusable pieces.

## Using Assigns

Assigns allow you to pass data into components - similar to properties or props in other frameworks. This is especially useful for customizing styling, content, or behavior.

To pass assigns, provide a two-element list: the component and a map of key-value pairs:

```
<%= r.([MyApp.Components.MyButton, %{color: "primary" }]) %>
```

Inside the component, these values can be accessed using the `@` sigil, just like in standard HEEx:

```html
<button class="<%= "btn-" <> @color %>">Click Me!</button>
```

In this example, the rendered output would be:

```html
<button class="btn-primary">Click Me!</button>
```
