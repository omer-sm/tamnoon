defmodule TamnoonTest do
  use ExUnit.Case
  doctest Tamnoon

  test "start server with default values" do
    children = [Tamnoon]
    opts = [strategy: :one_for_one, name: Tamnoon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  test "start server with non default values" do
    children = [{Tamnoon, [[port: 4040]]}]
    opts = [strategy: :one_for_one, name: Tamnoon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  test "defmethod macro working properly" do
    Tamnoon.Tst.tmnn_get(nil, nil)
  end

  test "route_request working properly" do
    Tamnoon.MethodManager.route_request(Tamnoon.Tst, %{"method" => "test_route"}, %{var: 1})
    |> IO.inspect()
  end
end
