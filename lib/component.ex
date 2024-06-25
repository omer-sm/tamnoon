defmodule Tamnoon.Component do
  @moduledoc """
  This module defines the `m:Tamnoon.Component` behaviour, which includes one callback -
  `c:heex/0`. It is good practice to implement this behaviour in a component module, however
  as long as you define a function named _heex_ taking 0 arguments and returning the heex,
  it should work just fine.
  """
  @callback heex :: String.t()
end
