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

  first_element: (collectionSelector) =>
    parseCollectionSelector(collectionSelector).first(),

  last_element: (collectionSelector) =>
    parseCollectionSelector(collectionSelector).last(),
};

const parseSingleSelector = (selector, addListeners = false) => {
  if (selector instanceof Node) {
    return selector;
  }

  const { selector_type: selectorType, selector_value: selectorValue } = selector;

  if (!selectorType || !selectorValue) {
    console.error(`Tamnoon: received invalid selector ${selector}`);
  } else {
    const node = singleSelectorParsers[selectorType](selectorValue);

    if (addListeners) {
      addInputListeners(node);
    }

    return node;
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

    return {
      first: () => result.iterateNext(),
      last: () => result.snapshotItem(result.snapshotLength - 1),
      forEach: (callback, argToIterate) => {
        callback.args[argToIterate] = result.iterateNext();

        while (callback[argToIterate]) {
          parseAction(callback);
          callback.args[argToIterate] = result.iterateNext();
        }
      },
    };
  },

  query: (query) => ({
    first: () => document.querySelector(query),
    last: () => {
      const elements = document.querySelectorAll(query);
      return elements.item(elements.length - 1);
    },
    forEach: (callback, argToIterate) => {
      document.querySelectorAll(query).forEach((element) => {
        callback.args[argToIterate] = element;
        parseAction(callback);
      });
    },
  }),

  children: (parent) => ({
    first: () => parseSingleSelector(parent).firstChild,
    last: () => parseSingleSelector(parent).lastChild,
    forEach: (callback, argToIterate) => {
      for (const element of parseSingleSelector(parent).children) {
        callback.args[argToIterate] = element;
        parseAction(callback);
      }
    },
  }),
};

const parseCollectionSelector = (selector) => {
  if (Array.isArray(selector) && selector.every((node) => node instanceof Node)) {
    return selector;
  }

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
    parseSingleSelector(target).replaceWith(parseSingleSelector(replacement, true)),

  AddChild: ({ parent, child }) =>
    parseSingleSelector(parent).append(parseSingleSelector(child, true)),

  SetAttribute: ({ target, attribute, value }) => {
    if (attribute === 'textContent') {
      parseSingleSelector(target).textContent = value;
    } else {
      parseSingleSelector(target).setAttribute(attribute, value);
    }
  },

  SetInnerHTML: ({target, value}) => {
    const node = parseSingleSelector(target);
    node.innerHTML = value;
    addInputListeners(node);
  },

  ToggleAttribute: ({ target, attribute, force }) =>
    parseSingleSelector(target).toggleAttribute(attribute, force),

  SetValue: ({ target, value }) => (parseSingleSelector(target).value = value),

  ForEach: ({ target, callback }) => {
    const [argToIterate] = Object.entries(callback.args).find(
      ([key, value]) => value?.selector_type === 'iteration_placeholder'
    );

    parseCollectionSelector(target).forEach(callback, argToIterate);
  },
};

const parseAction = (action) => {
  const { action: actionName, args: actionArgs } = action;

  if (!actionName || !actionArgs) {
    console.error(`Tamnoon: received invalid action ${action}`);
  } else {
    return actionParsers[actionName](actionArgs);
  }
};
