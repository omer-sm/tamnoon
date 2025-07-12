defmodule Tamnoon.Component do
  @moduledoc """
  This module defines the `m:Tamnoon.Component` behaviour, which includes the
  `c:heex/0` callback. It should be implemented in every component module.
  """

  @doc """
  Returns the raw HEEx code of the component.
  """
  @callback heex :: String.t()
end
