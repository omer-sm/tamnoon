defmodule Tamnoon.Components.Root do
  @behaviour Tamnoon.Component

  @impl true
  def heex do
    ~s"""
    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta name="description" content="Webpage description goes here" />
      <meta charset="utf-8">
      <title>title</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta name="tmnn_wsaddress" content="<%= @ws_address %>"/>
      <script src="ws_connect.js"></script>
    </head>

    <body>

        <div class="container">
            <%= r.("app.html.heex") %>
        </div>
    </body>
    </html>
    """
  end
end
