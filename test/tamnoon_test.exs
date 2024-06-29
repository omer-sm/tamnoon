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
    Tamnoon.TestCustomMethods.tmnn_get(nil, nil)
  end

  test "route_request working properly" do
    Tamnoon.MethodManager.route_request(Tamnoon.TestCustomMethods, %{"method" => "test_route"}, %{var: 1})
    |> IO.inspect()
  end

  test "default methods working properly" do
    assert Tamnoon.TestDefaultMethods.tmnn_get(%{"key" => "working?"}, %{working?: "true"})
    == {{:ok, "true"}, %{working?: "true"}}
  end

  test "tamnoon_methods module working properly 1" do
    assert Tamnoon.Methods.get(%{"key" => "working?"}, %{working?: "true"})
    == {{:ok, "true"}, %{working?: "true"}}
  end

  test "tamnoon_methods module working properly 2" do
    Tamnoon.MethodManager.route_request(Tamnoon.Methods, %{"method" => "get", "key" => "working?"}, %{working?: "true"})
    |> IO.inspect()
  end

  test "setting default state works properly" do
    children = [{Tamnoon, [[initial_state: %{working?: true}]]}]
    opts = [strategy: :one_for_one, name: Tamnoon.Supervisor]
    Supervisor.start_link(children, opts)
    assert Tamnoon.Tamnoon.Registry |> Registry.meta(:initial_state) |> elem(1) == %{working?: true}
  end

  test "html escape works properly" do
    str = "< > text & '\" more > text"
    assert Tamnoon.Compiler.escape_html(str) == "&lt; &gt; text &amp; &#39;&quot; more &gt; text"
  end
end
