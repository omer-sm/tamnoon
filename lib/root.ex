defmodule Tamnoon.Components.Root do
  @moduledoc false
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
        <script src="tamnoon_dom.js"></script>
        <script src="tamnoon_driver.js"></script>
      </head>

      <body>
          <%= r.("app.html.heex") %>
      </body>
    </html>
    """
  end
end
