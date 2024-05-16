defmodule Tamnoon.TestCustomMethods do
  import Tamnoon.MethodManager
  defmethod :get, do: IO.inspect("hi")
  defmethod :test_route do
    IO.inspect(req)
    {:ok, state}
  end
end
