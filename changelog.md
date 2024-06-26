# Changelog

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