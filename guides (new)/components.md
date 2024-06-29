# Components

In this guide, we will start writing the UI. From this point onwards, we will build a chat room app and add things to it in every guide.

In Tamnoon, the UI is made up of _components_. Components are reusable elements written in Tamnoon HEEx - an extension of HEEx (HTML + Elixir). Meaning, every HEEx code is valid Tamnoon HEEx code. Components can either be elixir modules that implement the `m:Tamnoon.Component` behaviour, or _.html.heex_ files located inside the `lib/components` directory. There is no difference between the two besides modules being able to utilize all of Elixir's features.

_Note: We will get back to Tamnoon HEEx later. For now, think of it as normal HEEx._

When a user retrieves the page, the "root" layout gets parsed and is returned. The root layout is a component module just like any other, and this is (partially) how it looks:

```
defmodule Tamnoon.Components.Root do
  @behaviour Tamnoon.Component

  @impl true
  def heex do
    ~s"""
    <!DOCTYPE html>
    <head>
      ...
      <meta name="tmnn_wsaddress" content="<%= @ws_address %>"/>
    </head>

    <body>
        <div class="app-container">
            <%= r.("app.html.heex") %>
        </div>
    </body>
    </html>
    """
  end
end
```

As you can see, it simply contains one function named "heex" that returns the Tamnoon HEEx. Note the `<%= r.("app.html.heex") %>`: This is an EEx block, that renders a component (In this case `"app.html.heex"`). Inside components you can use the `r.()` syntax to invoke `Tamnoon.Compiler.render_component_dyn/1`, which is the function that renders a component and can pass assigns to it.

Let's make the "app" component. Run `mix tamnoon.make_dirs`, which will generate a components directory and an output directory. Now, make a file named "app.html.heex" inside of your components directory (located at "lib/components"). Let's test that it works by writing the following inside of it:

```
<p> 1 + 1 = <%= 1 + 1 %> </p>
```

Run `mix run --no-halt`, visit _http://localhost:8000_, and you should see a blank page with the text _1 + 1 = 2_. Our Elixir block got parsed and our app is working as intended! 

## Making More Components

Let's make another component that will read the time from an _assign_, and will display a chat message. This time, let's make it a module. Inside your components directory, make a file named `message_box.ex` and write the following in it:

```
defmodule TamnoonChatroom.Components.MessageBox do
  @behaviour Tamnoon.Component
  
  @impl true
  def heex do
    ~s"""
    <div>
      <h4> <%= h.(@user_name) %> </h4>
      <p> <%= h.(@content) %> </p>
    </div>
    """
  end
end
```

In the component, we are rendering the `@user_name` and `@content` assigns. We are also using the `h.()` function, which is a shortcut for `Tamnoon.Compiler.escape_html/1` similar to `r.()`. This will prevent HTML injections to the page by escaping the necessary characters.

Now let's use it inside `"app.html.heex"`. Add the following to the file, restart the server and reload the page.

```
<%= r.([TamnoonChatroom.Components.MessageBox, %{user_name: "user1", content: "<h1> this is my message </h1>"}]) %>
```

You should now see "user1" displayed in bold text and the content of the message displayed under it, including the `<h1>` tags.

At this point, you have enough knowledge to create static pages. In the next guide we will go over the state and methods, which are how Tamnoon provides real-time updates.