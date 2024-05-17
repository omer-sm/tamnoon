defmodule Tamnoon.TestCustomMethods do
  @moduledoc false
  import Tamnoon.MethodManager
  defmethod :get, do: IO.inspect("hi")
  defmethod :test_route do
    IO.inspect(req)
    {:ok, state}
  end
end
