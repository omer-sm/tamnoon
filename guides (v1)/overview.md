# Overview

Tamnoon is a modern Elixir framework for building frontend web applications, designed to streamline and simplify development, and stay true to the principles of the language. It is built around the following core goals:

1. **Simplicity first** - Tamnoon adopts a clear, component-driven structure that reduces complexity and helps developers turn ideas into features with minimal friction.

2. **Zero boilerplate** - By removing unnecessary setup and configuration, Tamnoon enables fast, efficient development with clean and focused code.

3. **Functional by design** - Built to align with Elixir’s functional nature, Tamnoon encourages a pure, declarative style that fits naturally into the language.

## Guides

The following guides will walk you through the fundamentals of working with Tamnoon. A basic understanding of HTML is assumed, and while not required, familiarity with tools like React or Redux may help you get comfortable more quickly.

- [**Getting Started**](getting-started.html) - Installing Tamnoon and initializing a project.

- [**Components**](components.html) - An overview of components, including how to define, structure, and utilize them within your application.

- [**Methods**](methods.html) - Tamnoon's approach to defining behaviors and handling logic within components.

- [**PubSub**](pubsub.html) - Tamnoon's built-in support for publish-subscribe communication, enabling real-time updates and coordination between multiple connected clients.

- [**Tamnoon HEEx**](tamnoon-heex.html) - A guide to Tamnoon's templating language for components.

- [**DOM Actions**](dom-actions.html) - Mechanisms for directly interacting with the DOM outside of state management, to address edge cases and add low-level control.

## Sample Apps

If you learn best by example or just want a reference point, here are some sample applications built with Tamnoon:

- _[QR Generator](https://github.com/omer-sm/tamnoon_qr)_: A small app for generating QR codes. Demonstrates Tamnoon's basic usage in a minimal project.

- _[Wordle Clone](https://github.com/omer-sm/tamnoon_wordle)_: A clone of the NYT's popular game Wordle. Demonstrates input validation and more dynamic usage of components.

- _[Tic-Tac-Toe](https://github.com/omer-sm/tamnoon_ttt)_: An app for playing Tic-Tac-Toe with others online. Demonstrates complex PubSub logic.

- _[Cameras](https://github.com/omer-sm/tamnoon_cameras)_: An app demonstrating usage of Tamnoon in a microservice architecture via RabbitMQ.

- _[Chatroom](https://github.com/omer-sm/tamnoon_chat)_: A chat app with rooms and users, demonstrating Tamnoon's PubSub functionality and communication with a Phoenix backend.

_Note: This section is WIP and will be expanded in the future._