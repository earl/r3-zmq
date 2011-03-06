REBOL [
    title: "ØMQ extension"
    author: "Andreas Bolka"
    name: zmqext
    type: extension
    rights: {
        Copyright (C) 2011 Andreas Bolka <a AT bolka DOT at>
        Licensed under the terms of the Apache License, Version 2.0

        The zmqext REBOL 3 extension uses the ØMQ library, the use of which is
        granted under the terms of the GNU Lesser General Public License
        (LGPL), Version 3.
    }
]

export zmq-constants: map [
    ;; socket types
    pair 0
    pub 1
    sub 2
    req 3
    rep 4
    xreq 5
    xrep 6
    pull 7
    push 8

    ;; socket options
    hwm 1
    swap 3
    affinity 4
    identity 5
    subscribe 6
    unsubscribe 7
    rate 8
    recovery-ivl 9
    mcast-loop 10
    sndbuf 11
    rcvbuf 12
    rcvmore 13

    ;; send/recv options
    noblock 1
    sndmore 2
]

export zmq-init: command [
    "Initialise 0MQ context"
    io-threads [integer!]
]

export zmq-term: command [
    "Terminate 0MQ context"
    ctx [handle!]
]

export zmq-msg-alloc: command [
    "Allocate memory for a 0MQ message object"
]

export zmq-msg-free: command [
    "Free the memory previously allocated for a 0MQ message object"
    msg [handle!]
]

export zmq-msg-init: command [
    "Initialise empty 0MQ message"
    msg [handle!]
]

export zmq-msg-init-size: command [
    "Initialise 0MQ message of a specified size"
    msg [handle!]
    size [integer!]
]

export zmq-msg-init-data: command [
    "Initialise 0MQ message with the supplied data"
    msg [handle!]
    data [binary!]
]

export zmq-msg-close: command [
    "Release 0MQ message"
    msg [handle!]
]

export zmq-msg-data: command [
    "Retrieve message content (as binary!)"
    msg [handle!]
]

export zmq-msg-size: command [
    "Retrieve message content size in bytes"
    msg [handle!]
]

export zmq-msg-copy: command [
    "Copy content of a message to another message"
    msg-dest [handle!]
    msg-src [handle!]
]

export zmq-msg-move: command [
    "Move content of a message to another message"
    msg-dest [handle!]
    msg-src [handle!]
]

export zmq-socket: command [
    "Create 0MQ socket"
    ctx [handle!]
    type [integer!]
]

export zmq-close: command [
    "Close 0MQ socket"
    socket [handle!]
]

export zmq-setsockopt-binary: command [
    "Set 0MQ socket options (of 0MQ option value type 'binary')"
    socket [handle!]
    name [integer!]
    value [binary!]
]

export zmq-getsockopt-binary: command [
    "Get 0MQ socket options (of 0MQ option value type 'binary')"
    socket [handle!]
    name [integer!]
    size [integer!]
]

export zmq-setsockopt-int: command [
    "Set 0MQ socket options (of 0MQ option value type '[u]int64_t')"
    socket [handle!]
    name [integer!]
    value [integer!]
]

export zmq-getsockopt-int: command [
    "Get 0MQ socket options (of 0MQ option value type '[u]int64_t')"
    socket [handle!]
    name [integer!]
]

export zmq-bind: command [
    "Accept connections on a socket"
    socket [handle!]
    endpoint [string!]
]

export zmq-connect: command [
    "Connect a socket"
    socket [handle!]
    endpoint [string!]
]

export zmq-send: command [
    "Send a message on a socket"
    socket [handle!]
    msg [handle!]
    flags [integer!]
]

export zmq-recv: command [
    "Receive a message from a socket"
    socket [handle!]
    msg [handle!]
    flags [integer!]
]

; @@ poll?

export zmq-errno: command [
    "Retrieve the error code"
]

export zmq-strerror: command [
    "Get 0MQ error message string for a given error code"
    errnum [integer!]
]

export zmq-version: command [
    "Report 0MQ library version"
]
