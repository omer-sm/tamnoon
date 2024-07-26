# Changelog

### V1.0.0-a.3 (25.07.24)

- Added support for running Tamnoon over HTTPS.

- Added support for Mix Releases (via `Tamnoon.make_release/1`). 

- Updated the client script to try reconnecting to the server if it disconnects.

- Updated the client script to keep a copy of the state which will be sent to the server on a reconnect. _Note: this also means that string keys in the state are now not supported, as the state will have its keys converted to atoms on the reconnect._

#### Minor Changes:

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