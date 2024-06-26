const wsUrl = document.getElementsByName("tmnn_wsaddress")[0].content
const socket = new WebSocket(wsUrl)
socket.onopen = function (event) {
    setInterval(() => {
        socket.send(JSON.stringify({
            "method": "keep_alive"
        }))
    }, 55000)
    document.querySelectorAll(`[class^="tmnnevent-"], [class*=" tmnnevent-"]`).forEach(elem => {
        const classes = elem.className.split(/\s+/).filter(c => c)
        classes.forEach(className => {
            const methodName = className.slice(className.lastIndexOf("-") + 1)
            const eventName = className.slice(12, -methodName.length - 1)
            elem.addEventListener(eventName, e => {
                socket.send(JSON.stringify({
                    "method": methodName,
                    "val": e.target.value,
                    "element": e.target.outerHTML
                }))
            })
        })
    })
    socket.send(JSON.stringify({
        "method": "sync"
    }))
}

socket.onmessage = function (event) {
    const diffs = JSON.parse(event.data)
    if (!diffs) return
    for (const [k, v] of Object.entries(diffs)) {
        if (k !== "error") {
            document.querySelectorAll(`[class^="tmnn-${k}-"], [class*=" tmnn-${k}-"]`).forEach(elem => {
                const classes = elem.className.split(/\s+/).filter(c => c)
                classes.forEach(className => {
                    const attr = className.slice(className.lastIndexOf("-") + 1)
                    switch (attr) {
                        case "innerHtml":
                            elem.innerHTML = v
                            break
                        case "hidden":
                            elem.hidden = v
                            break
                        default:
                            elem.setAttribute(attr, v)
                            break
                    }
                })
            })
        }
    }
}

socket.onclose = function (event) {
    console.log("Tamnoon: WebSocket is closed now.")
}

socket.onerror = function (error) {
    console.log("Tamnoon: WebSocket error:", error)
}