defmodule Tamnoon do
  @moduledoc """
  This module provides functions needed to initialize Tamnoon. You do not need to handle
  it directly, rather, the only time you need to call something in this module is in your
  supervision tree, to add it to the children and configure it (see `child_spec/1`).
  ## Example
  ```
  def start_link(opts \\\\ []) do
    children = [Tamnoon]
    opts = [strategy: :one_for_one, name: Tamnoon.Supervisor]
    Supervisor.start_link(children, opts)
  end
  ```
  """
  require Logger
  @typedoc """
  Options for initializing Tamnoon. Defaults to `[4000, Tamnoon.Router, Tamnoon.SocketHandler, Tamnoon.Methods, %{}]`.
  """
  @type tamnoon_opts() :: [port: number(), router: module(), socket_handler: module(),
                          methods_module: module(), initial_state: map()]

  @doc """
  Returns a Tamnoon server supervisor child spec. See `tamnoon_opts/0` for more info.
  """
  @spec child_spec(opts :: tamnoon_opts()) :: map()
  def child_spec(opts \\ []) do
    %{
      id: Tamnoon.Supervisor,
      start: {Tamnoon, :start_link, opts}
    }
  end

  @doc false
  @spec start_link() :: {:ok, pid()}
  def start_link(), do: start_link([])

  @doc """
  Starts the supervisor. See `tamnoon_opts/0` for more info.
  """
  @spec start_link(server_opts :: tamnoon_opts()) :: {:ok, pid()} | {:error, {:already_started, pid()} | {:shutdown, term()} | term()}
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
        name: Tamnoon.Registry,
        meta: [initial_state: Keyword.get(server_opts, :initial_state, %{}),
              methods_module: Keyword.get(server_opts, :methods_module, Tamnoon.Methods)]
      )
    ]
    opts = [strategy: :one_for_one, name: Tamnoon.ServerSupervisor]
    Logger.info("Tamnoon listening on port #{port}..")
    Supervisor.start_link(children, opts)
  end

  @doc false
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
