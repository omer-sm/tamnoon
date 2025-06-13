# Changelog

### v1.0.0-a.5

- Made Tamnoon HEEx values invertable: for example, assigning @not-some_value to an attribute will turn it `true` when `some_value` is `false`, and vice versa.

- Added the `tamnoon.setup` task, which runs all recommended tasks for starting a new Tamnoon app.

- Removed the _app-container_ div from the default root, and fixed the indentation in its HTML.

- Fixed a bug where `Tamnoon.MethodManager.defmethod/2` caused a _no match found_ error.


#### Minor changes:

- Fixed a bug where live reload did not reload some changes for the client that triggered it.

- Removed the (empty) documentation page for the default root component.

- Altered the "no method found" error message to be clearer. 

- Made the `m:Tamnoon.Component` documentation more concise.


### v1.0.0-a.4 (05.06.25)

- Added **live reload**. When not disabled, Tamnoon will automatically recompile when new connections are made (including existing connections refreshing the page). 

- Changed method modules such that now multiple modules are used instead of a singular one. Deprecated the `__using__` macro of `m:Tamnoon.Methods` because of this too.

- Added the `tamnoon.override_root` Mix task. The task generates a router and a root component for you.

- Added **debug mode**. Enabling it will log the payload and current state whenever a method is triggered.

- Added `Tamnoon.MethodManager.diff/2`.

- Added `Tamnoon.MethodManager.trigger_method/3`.

- Fixed bugs where unrelated HTML classes interfere with Tamnoon classes.

- Added support for setting initial_state as a function, allowing the initial state to be recomputed for every client.

- Silenced the _unused variable "req"_ warnings for methods. 


### v1.0.0-a.3 (25.07.24)

- Added support for running Tamnoon over HTTPS.

- Added support for Mix Releases (via `Tamnoon.make_release/1`). 

- Updated the client script to try reconnecting to the server if it disconnects.

- Updated the client script to keep a copy of the state which will be sent to the server on a reconnect. _Note: this also means that string keys in the state are now not supported, as the state will have its keys converted to atoms on the reconnect._


#### Minor changes:

- Added `Tamnoon.Methods.tmnn_set_state/2`.

- Added deployment guide (WIP)


### v1.0.0-a.2 (29.06.24)

- Added **implicit events**: setting an input event attribute (such as onchange) to `@method-key` will make it fire the method with the specified key. The `"pub"` method can be triggered like so: `@pub-[channel]-[method]-[key (optional)]`.

- A component with a Tamnoon variable inside it (`<p>@val</p>`) will now set the inner text of the element instead of the inner HTML. The inner HTML can be set by prefixing the variable name with "raw-" like so: `<p>@raw-val</p>`.

- Added the `mix tamnoon.make_dirs` task that creates a "lib/components" directory and a "tamnoon_out" directory.

- Added `Tamnoon.Compiler.escape_html/1` and made it available as `<%= h.(content) %>` inside components.

- Completely rewrote the guides, the readme, and revamped some of the existing module documentation.

#### Minor changes:

- Changed the default port to 8000 from 4000.

- Fixed "imported function conflicts with local function" when invoking a method handler inside the methods module.

- Fixed the client-side handling of updates for elements with the "value" attribute not functioning properly.

- Changed the WebSocket script in the root layout to connect to the WebSocket at the current URL (instead of _localhost:8000/ws_).

- Changed `Tamnoon.Compiler.build_from_root/1` to no longer accept a WebSocket address.


### v1.0.0-a.1 (26.06.24)

- Added the _sync_ method (`Tamnoon.Methods.tmnn_sync/2`) that returns the current state to the client. By default, it is invoked when the WebSocket connection is opened.

- Added the _keep\_alive_ method (`Tamnoon.Methods.tmnn_keep_alive/2`) that is invoked every 55 seconds by the client in order to prevent idle timeouts.

- Moved the WebSocket connection script to a separate file, and updated the default router (`m:Tamnoon.Router`) to serve a default root layout.


#### Minor changes:

- Changed the console message sent when Tamnoon starts to include the full address.

- Changed `Tamnoon.SocketHandler.init/2` so connections have a 120 second idle timeout (instead of 60).

- Added `Tamnoon.Compiler.render_component_dyn/1`.

- Changed `Tamnoon.Compiler.render_component/3` so using `<%= r.(args..) %>` will call `Tamnoon.Compiler.render_component_dyn/1` instead of `Tamnoon.Compiler.render_component/1`, to allow passing in multiple arguments.

- Added (temporary) documentation.


### v1.0.0-a.0 (25.06.24)

Added support for HEEx components and changed the default router to display the root page by default.


### v0.1.1

Very minor changes.


### v0.1.0

First release.