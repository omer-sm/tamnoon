# DOM Actions

_DOM Actions_ provide targeted, low-level manipulation of the DOM without requiring interaction with the state. They closely resemble the browser's native DOM API, offering fine-grained control and serving as an escape hatch from Tamnoon's state-driven model.

While Tamnoon's state model is suited for most use cases, some scenarios benefit from direct DOM manipulation. DOM Actions are especially useful in the following cases:

#### Lists

Actions such as `m:Tamnoon.DOM.Actions.AddChild` and `m:Tamnoon.DOM.Actions.RemoveNode` enable you to manage long or dynamic lists efficiently. This avoids the overhead of updating and re-rendering the entire list through state changes.

#### Lazy Inputs

Inputs in Tamnoon are typically bound using `value`, meaning each change triggers a state sync with the server. This can introduce latency during typing. Instead, you can remove the `value` assignment and use `m:Tamnoon.DOM.Actions.SetValue` to manually change the input's value when needed. This approach improves responsiveness while still enabling programmatic control.

#### Minimal State

State fields can accumulate values used in only one place - for example, toggling the visibility of a button. Using actions like `m:Tamnoon.DOM.Actions.ToggleAttribute`, you can handle such logic directly in the DOM, keeping your state clean and focused only on the data that matters.

## In Practice

To execute a _DOM action_, it must first be _constructed_ and then _returned from a method_. DOM actions are a specialized kind of _DOM struct_ - data structures that resemble an abstract syntax tree (AST) and encode what to do, to which elements, and how.

### Constructing a DOM Action

To construct a DOM action, call its `new!/1` function and pass in a map with the required arguments. These arguments can be _literals_ (e.g., strings, booleans) or other DOM structs (such as nodes or node collections).

Each action has its own set of required fields - refer to its `new!/1` documentation for the specific structure.

### DOM Structs

DOM structs are structured representations of operations and elements in the DOM. They are the building blocks for DOM actions, and they fall into one of the following categories:

- **Action** - Represents _what_ to do. For example: `m:Tamnoon.DOM.Actions.RemoveNode` removes a node from the DOM.

- **Node** - Represents a single DOM node, i.e. _what_ the action is applied to. See `m:Tamnoon.DOM.Node`.

- **Node Collection** Represents a group of DOM elements that are _targets_ of the action. See `m:Tamnoon.DOM.NodeCollection`.

#### Example

The following method clears the input field with the ID `"message-input"`:

```
defmethod :clear_message_input do
  input_node = Tamnoon.DOM.Node.new!(%{
    selector_type: :id,
    selector_value: "message-input"
  })

  clear_action = Tamnoon.DOM.Actions.SetValue.new!(%{
    target: input_node,
    value: ""
  })

  {%{}, [clear_action]}
end
```

In this example:

- A DOM node is constructed to target the input with ID `"message-input"`.

- A `SetValue` action is created to set its value to an empty string.

- The action is returned from the method (alongside an empty diffs map), and will be executed on the client.

### Node Collections & ForEach

To apply actions to multiple DOM elements, you can use a _node collection_ together with the `m:Tamnoon.DOM.Actions.ForEach` action.

Unlike most actions, `ForEach` is special in that it:

1. Accepts another action as a parameter (the `:callback` parameter)

2. Uses a special _iteration placeholder_ as the target inside that callback. This placeholder represents each node in the collection as it's iterated.

#### Example

```
Tamnoon.DOM.Actions.ForEach.new!(%{
  target:
    Tamnoon.DOM.NodeCollection.new!(%{
      selector_type: :query,
      selector_value: ".toggle-me"
    }),
  callback:
    Tamnoon.DOM.Actions.ToggleAttribute.new!(%{
      target:
        Tamnoon.DOM.Node.new!(%{
          selector_type: :iteration_placeholder,
          selector_value: nil
        }),
        attribute: "hidden"
    })
})
```

In this example:

- The `:target` is a node collection selecting all elements with the `"toggle-me"` class.

- The `:callback` is a `ToggleAttribute` action that:

  - Targets each node in the collection (via the `:iteration_placeholder` selector).

  - Toggles its `"hidden"` attribute.

This results in every `".toggle-me"` element being shown or hidden depending on its current state.

#### The Iteration Placeholder

The _iteration placeholder_ represents a node that will be dynamically replaced with each element from the `:target` node collection during a `ForEach` operation.

As shown in the example, an iteration placeholder node is constructed as follows:

```
Tamnoon.DOM.Node.new!(%{
  selector_type: :iteration_placeholder,
  selector_value: nil
})
```

> Note: The iteration placeholder is only valid within the context of a `ForEach` action. It is not intended for use outside of that context and will not function correctly elsewhere.
