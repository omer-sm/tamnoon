defmodule Tamnoon.DOM do
  @doc """
  Raises an `m:ArgumentError` if `check_fun.(value)` evaluates to `false`.
  Returns :ok otherwise.
  """
  @spec validate_type!(
          value :: any(),
          check_fun :: (term() -> boolean()),
          struct_module :: module()
        ) :: :ok
  def validate_type!(value, check_fun, struct_module) do
    if !check_fun.(value) do
      raise(
        ArgumentError,
        "expected a %#{inspect(struct_module)}{} struct or similar map, got: #{inspect(value)}"
      )
    end

    :ok
  end
end
