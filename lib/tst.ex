defmodule Tamnoon.Tst do
  require Tamnoon.MethodManager
  Tamnoon.MethodManager.defmethod :get, do: IO.inspect("hi")
  Tamnoon.MethodManager.defmethod :test_route do
    IO.inspect(req)
    {:ok, state}
  end
end
