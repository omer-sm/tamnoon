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

  test "new node collection from query" do
    expected = %DOM.NodeCollection{selector_type: :query, selector_value: ".my-class"}
    actual = DOM.NodeCollection.new!(%{selector_type: :query, selector_value: ".my-class"})

    assert expected == actual
  end

  test "new add child" do
    node = DOM.Node.new!(%{selector_type: :id, selector_value: "my-id"})
    expected = %DOM.Actions.AddChild{parent: node, child: node}
    actual = DOM.Actions.AddChild.new!(%{parent: node, child: node})

    assert expected == actual
  end

  test "toggle attribute without force is valid" do
    node = DOM.Node.new!(%{selector_type: :id, selector_value: "my-id"})
    expected = %DOM.Actions.ToggleAttribute{target: node, attribute: "hidden"}
    actual = DOM.Actions.ToggleAttribute.new!(%{target: node, attribute: "hidden"})

    assert expected == actual
  end

  test "toggle attribute with force is valid" do
    node = DOM.Node.new!(%{selector_type: :id, selector_value: "my-id"})
    expected = %DOM.Actions.ToggleAttribute{target: node, attribute: "hidden", force: true}
    actual = DOM.Actions.ToggleAttribute.new!(%{target: node, attribute: "hidden", force: true})

    assert expected == actual
  end
end
