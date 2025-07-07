const singleSelectorParsers = {
  id: document.getElementById.bind(document),
  from_string: (elementString) => {
    const template = document.createElement('template');
    template.innerHTML = elementString.trim();

    return template.content.firstChild;
  },
  xpath: (xpathString) =>
    document.evaluate(
      xpathString,
      document,
      null,
      XPathResult.FIRST_ORDERED_NODE_TYPE,
      null
    ).singleNodeValue,
  first_element: (collectionSelector) => parseCollectionSelector(collectionSelector)[0],
  last_element: (collectionSelector) => {
    const collection = parseCollectionSelector(collectionSelector);

    return collection[collection.length - 1];
  },
};

const parseSingleSelector = (selector) => {
  const { selector_type: selectorType, selector_value: selectorValue } = selector;

  if (!selectorType || !selectorValue) {
    console.error(`Tamnoon: received invalid selector ${selector}`);
  } else {
    return singleSelectorParsers[selectorType](selectorValue);
  }
};

const collectionSelectorParsers = {
  xpath: (xpathString) => {
    const result = document.evaluate(
      xpathString,
      document,
      null,
      XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,
      null
    );

    return Array.from({ length: result.snapshotLength }, (_, i) =>
      result.snapshotItem(i)
    );
  },
  query: (query) => [...document.querySelectorAll(query)],
  children: (parent) => parseSingleSelector(parent).children,
};

const parseCollectionSelector = (selector) => {
  const { selector_type: selectorType, selector_value: selectorValue } = selector;

  if (!selectorType || !selectorValue) {
    console.error(`Tamnoon: received invalid selector ${selector}`);
  } else {
    return collectionSelectorParsers[selectorType](selectorValue);
  }
};

const actionParsers = {
  RemoveNode: ({ target }) => parseSingleSelector(target).remove(),
  ReplaceNode: ({ target, replacement }) =>
    parseSingleSelector(target).replaceWith(parseSingleSelector(replacement)),
  AddChild: ({ parent, child }) =>
    parseSingleSelector(parent).append(parseSingleSelector(child)),
  SetAttribute: ({ target, attribute, value }) =>
    parseSingleSelector(target).setAttribute(attribute, value),
  ToggleAttribute: ({ target, attribute, force }) =>
    parseSingleSelector(target).toggleAttribute(attribute, force),
  SetValue: ({ target, value }) => (parseSingleSelector(target).value = value),
};

const parseAction = (action) => {
  const { action: actionName, args: actionArgs } = action;

  if (!actionName || !actionArgs) {
    console.error(`Tamnoon: received invalid action ${action}`);
  } else {
    return actionParsers[actionName](actionArgs);
  }
};
