defmodule Tamnoon do
  @moduledoc """
  TBA
  """
  require Logger
  @doc """
  Returns a Tamnoon server supervisor child spec. invoked when adding Tamnoon to the
  supervision tree.
  """

  def child_spec(opts \\ []) do
    %{
      id: Tamnoon.Supervisor,
      start: {Tamnoon, :start_link, opts}
    }
  end

  @doc """
  See `start_link/1`
  """
  @spec start_link() :: {:ok, pid()}
  def start_link(), do: start_link([])

  @doc """
  Starts the supervisor. takes options for port, router and socket handler.
  """
  def start_link(server_opts) do
    router = Keyword.get(server_opts, :router, Tamnoon.Router)
    port = Keyword.get(server_opts, :port, 4000)
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: router,
        options: [
          dispatch: dispatch(Keyword.get(server_opts, :socket_handler, Tamnoon.SocketHandler), router),
          port: port,
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Tamnoon.Registry
      )
    ]
    opts = [strategy: :one_for_one, name: Tamnoon.ServerSupervisor]
    Logger.info("Tamnoon listening on port #{port}..")
    Supervisor.start_link(children, opts)
  end

  def dispatch(socket_handler, router) do
    [
      {:_,
        [
          {"/ws/[...]", socket_handler, []},
          {:_, Plug.Cowboy.Handler, {router, []}}
        ]
      }
    ]
  end

end
