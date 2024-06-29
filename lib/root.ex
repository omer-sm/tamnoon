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
      <title>Tamnoon App</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <script src="ws_connect.js"></script>
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
