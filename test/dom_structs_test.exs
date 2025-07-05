defmodule DomStructsTest do
  alias Tamnoon.DOM
  use ExUnit.Case

  test "new node from id" do
    expected = %DOM.Node{selector_type: :id, selector_value: "my-id"}
    actual = DOM.Node.new!(%{selector_type: :id, selector_value: "my-id"})

    assert expected == actual
  end

  test "new node without type fails" do
    assert_raise(ArgumentError, fn -> DOM.Node.new!(%{selector_value: "my-id"}) end)
  end

  test "new node collection from children" do
    node = DOM.Node.new!(%{selector_type: :id, selector_value: "my-id"})
    expected = %DOM.NodeCollection{selector_type: :children, selector_value: node}
    actual = DOM.NodeCollection.new!(%{selector_type: :children, selector_value: node})

    assert expected == actual
  end
end
