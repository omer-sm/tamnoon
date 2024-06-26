defmodule Tamnoon.Router do
  @moduledoc """
  This module provides a default router for HTTP(S) requests, returning a 404 status
  to all of them. This is useful in order to only serve Websocket requests, however
  creating a custom one configured to serve a website might be beneficial. If you wish to
  do so, see `m:Plug.Router` and `Tamnoon.child_spec/1`.
  """

  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    Tamnoon.Compiler.build_from_root()
    send_file(conn, 200, "tamnoon_out/app.html")
  end

  get "/ws_connect.js" do
    send_file(conn, 200, Application.app_dir(:tamnoon, "priv/static/ws_connect.js"))
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
