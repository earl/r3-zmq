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
    dealer 5 ;; >= 0MQ 2.1
    router 6 ;; >= 0MQ 2.1
    pull 7
    push 8

    xreq 5 ;; deprecated in 0MQ 2.1
    xrep 6 ;; deprecated in 0MQ 2.1

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
    fd 14 ;; >= 0MQ 2.1
    events 15 ;; >= 0MQ 2.1
    type 16 ;; >= 0MQ 2.1
    linger 17 ;; >= 0MQ 2.1
    reconnect-ivl 18 ;; >= 0MQ 2.1
    backlog 19 ;; >= 0MQ 2.1
    recovery-ivl-msec 20 ;; >= 0MQ 2.1
    reconnect-ivl-max 21 ;; >= 0MQ 2.1

    ;; send/recv options
    noblock 1
    sndmore 2

    ;; poll options
    pollin 1
    pollout 2
    ;pollerr 4 ;; not used for 0MQ sockets (& we can't support standard sockets)

    ;; device options
    streamer 1 ;; >= 0MQ 2.0.11
    forwarder 2 ;; >= 0MQ 2.0.11
    queue 3 ;; >= 0MQ 2.0.11

    ;; useful error codes
    eintr 4
    eagain 11
]

export zmq-init: command [ ;; >= 0MQ 2.0.7
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
    "Initialise 0MQ message with (a copy of) supplied data"
    msg [handle!]
    data [binary!]
]

export zmq-msg-close: command [
    "Release 0MQ message"
    msg [handle!]
]

export zmq-msg-data: command [
    "Retrieve (copy of) message content (as binary!)"
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
    endpoint [string! url!]
]

export zmq-connect: command [
    "Connect a socket"
    socket [handle!]
    endpoint [string! url!]
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

export zmq-poll: command [
    "Input/output multiplexing"
    poll-spec [block!]
    timeout [integer!] "Timeout in microseconds"
]

export zmq-device: command [ ;; >= 0MQ 2.0.11
    "Start build-in 0MQ device"
    device [integer!]
    frontend [handle!]
    backend [handle!]
]

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

;; Temporary workaround for bug#1868
export zmq-equal?: command [
    "Returns TRUE if two 0MQ handle! values are equal"
    value1 [handle!]
    value2 [handle!]
]
