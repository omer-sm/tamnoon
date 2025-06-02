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
  Options for initializing Tamnoon. Defaults to `[8000, Tamnoon.Router, Tamnoon.SocketHandler, Tamnoon.Methods, %{}]`.
  - `port`: The port Tamnoon will run on. Defaults to _8000_.
  - `initial_state`: A map, or a function that returns one, representing the state new clients will start with. Defaults to an empty map.
  - `methods_module`: The module where your methods are defined (see `m:Tamnoon.Methods`). Defaults to `m:Tamnoon.Methods`.
  - `router`: The router module (see `m:Plug.Router`). Defaults to `m:Tamnoon.Router`.
  - `socket_handler`: The handler module for WebSocket requests. Usually doesn't need to be overriden. Defaults to `m:Tamnoon.SocketHandler`.
  - `protocol_opts`: Whether Tamnoon uses HTTP or HTTPS. See `t:tamnoon_protocol_opts/0` for more info.
  """
  @type tamnoon_opts() :: [
          initial_state: (-> map()) | map(),
          port: number(),
          methods_module: module(),
          router: module(),
          socket_handler: module(),
          protocol_opts: tamnoon_protocol_opts()
        ]

  @typedoc """
  Options for configuring the protocol used by Tamnoon. Can be either `:http` or a keyword list containing
  values for `:keyfile`, `:certfile`, and `:otp_app` *(`:otp_app` is required only when using relative paths for the
  key and certificate files)*. Defaults to `:http`.
  """
  @type tamnoon_protocol_opts() ::
          :http | [keyfile: String.t(), certfile: String.t(), otp_app: atom()]

  @doc """
  Returns a Tamnoon server supervisor child spec. See `t:tamnoon_opts/0` for more info.
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
  Starts the supervisor. See `t:tamnoon_opts/0` for more info.
  """
  @spec start_link(server_opts :: tamnoon_opts()) ::
          {:ok, pid()} | {:error, {:already_started, pid()} | {:shutdown, term()} | term()}
  def start_link(server_opts) do
    router = Keyword.get(server_opts, :router, Tamnoon.Router)
    port = Keyword.get(server_opts, :port, 8000)

    protocol_opts = Keyword.get(server_opts, :protocol_opts, :http)

    {protocol, certfile, keyfile, otp_app} =
      if protocol_opts == :http do
        {:http, nil, nil, nil}
      else
        {:https, Keyword.get(protocol_opts, :certfile, nil),
         Keyword.get(protocol_opts, :keyfile, nil), Keyword.get(protocol_opts, :otp_app, nil)}
      end

    cowboy_opts =
      [
        dispatch:
          dispatch(Keyword.get(server_opts, :socket_handler, Tamnoon.SocketHandler), router),
        port: port,
        certfile: certfile,
        keyfile: keyfile,
        otp_app: otp_app
      ]
      |> Keyword.filter(&elem(&1, 1))

    children = [
      Plug.Cowboy.child_spec(
        scheme: protocol,
        plug: router,
        options: cowboy_opts
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Tamnoon.Registry,
        meta: [
          initial_state: Keyword.get(server_opts, :initial_state, %{}),
          methods_module: Keyword.get(server_opts, :methods_module, Tamnoon.Methods)
        ]
      )
    ]

    opts = [strategy: :one_for_one, name: Tamnoon.ServerSupervisor]
    Logger.info("Tamnoon listening on #{protocol}://localhost:#{port}..")
    Supervisor.start_link(children, opts)
  end

  @doc false
  def dispatch(socket_handler, router) do
    [
      {:_,
       [
         {"/ws/[...]", socket_handler, []},
         {:_, Plug.Cowboy.Handler, {router, []}}
       ]}
    ]
  end

  @doc """
  Copies HEEx file components to the release directory and creates a _tamnoon\_out_ directory
  in it. It is needed to be ran as a _step_ in the release (see `m:Mix.Release`).
  """
  @spec make_release(Mix.Release) :: Mix.Release
  def make_release(release) do
    File.mkdir("#{release.path}/bin/tamnoon_out")
    File.mkdir("#{release.path}/bin/lib")
    File.mkdir("#{release.path}/bin/lib/components")

    File.ls("lib/components")
    |> elem(1)
    |> Enum.filter(&String.ends_with?(&1, ".heex"))
    |> Enum.each(&File.copy!("lib/components/#{&1}", "#{release.path}/bin/lib/components/#{&1}"))

    release
  end
end
