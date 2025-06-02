const url = new URL(document.location.href);
url.protocol = url.protocol === 'http:' ? 'ws:' : 'wss:';
url.pathname += 'ws';
const wsUrl = url.toString();
const curr_state = {};
let socket;
const inputListeners = [];

const connectWebSocket = (isReconnect = false) => {
  socket = new WebSocket(wsUrl);

  socket.onopen = function (event) {
    console.log('Tamnoon: WebSocket is open now.');
    // Start firing the keep alive method every 55 seconds to maintain the connection.
    setInterval(() => {
      socket.send(
        JSON.stringify({
          method: 'keep_alive',
        })
      );
    }, 55000);

    // Add event listeners to elements with the appropriate classes.
    document
      .querySelectorAll(`[class^="tmnnevent-"], [class*=" tmnnevent-"]`)
      .forEach((elem) => {
        const classes = elem.className
          .split(/\s+/)
          .filter((c) => c && c.startsWith('tmnnevent-'));

        classes.forEach((className) => {
          const classNameSplit = className.split('-');
          const methodName = classNameSplit[2];
          const eventName = classNameSplit[1].slice(2);

          const eventListener = (e) => {
            let msg = {
              method: methodName,
              val: e.target.value,
              element: e.target.outerHTML,
            };

            if (methodName === 'pub') {
              msg['channel'] = classNameSplit[3];
              msg['action'] = {
                method: classNameSplit[4],
                val: e.target.value,
                element: e.target.outerHTML,
              };

              if (classNameSplit.length === 6) {
                msg['action']['key'] = classNameSplit[5];
              }
            } else if (classNameSplit.length === 4) {
              msg['key'] = classNameSplit[3];
            }

            // Possible values for classNameSplit:
            // ["tmnnevent", inEvent, method]
            // ["tmnnevent", inEvent, method, key]
            // ["tmnnevent", inEvent, "pub", channel, method]
            // ["tmnnevent", inEvent, "pub", channel, method, key]
            socket.send(JSON.stringify(msg));
          };

          elem.addEventListener(eventName, eventListener);
          inputListeners.push({ elem, eventName, eventListener });
        });
      });

    // Get all the initial values from the server.
    if (isReconnect) {
      socket.send(
        JSON.stringify({
          method: 'set_state',
          state: curr_state,
        })
      );
    } else {
      socket.send(
        JSON.stringify({
          method: 'sync',
        })
      );
    }
  };

  socket.onmessage = function (event) {
    // Parse the server's message to update the necessary elements.
    const diffs = JSON.parse(event.data);

    if (!diffs) return;
    for (const [k, v] of Object.entries(diffs)) {
      if (k !== 'error') {
        if (!(k in ['pub', 'sub', 'unsub', 'subbed_channels', 'set_state'])) {
          curr_state[k] = v;
        }

        // Update the elements with the class that matches the key.
        document
          .querySelectorAll(`[class^="tmnn-${k}-"], [class*=" tmnn-${k}-"]`)
          .forEach((elem) => {
            const classes = elem.className
              .split(/\s+/)
              .filter((c) => c && c.startsWith(`tmnn-${k}-`));

            classes.forEach((className) => {
              const attr = className.slice(className.lastIndexOf('-') + 1);

              switch (attr) {
                case 'innerHtml':
                  elem.innerHTML = v;
                  break;
                case 'innerText':
                  elem.innerText = v;
                  break;
                case 'value':
                  elem.value = v;
                  break;
                case 'hidden':
                  elem.hidden = v;
                  break;
                default:
                  elem.setAttribute(attr, v);
                  break;
              }
            });
          });
      }
    }
  };

  socket.onclose = function (event) {
    console.log('Tamnoon: WebSocket is closed now.');

    inputListeners.forEach(({ elem, eventName, eventListener }) => {
      elem.removeEventListener(eventName, eventListener);
    });

    setTimeout(() => {
      connectWebSocket(true);
    }, 1000);
  };

  socket.onerror = function (error) {
    console.log('Tamnoon: WebSocket error:', error);
    socket.close();
  };
};

connectWebSocket();
