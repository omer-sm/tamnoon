defmodule Tamnoon.Router do
  @moduledoc """
  This module provides a default router for HTTP(S) requests, which builds and serves the web app.
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
