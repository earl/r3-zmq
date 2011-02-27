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

export zmq-init: command [io-threads [integer!]]
export zmq-term: command [ctx [handle!]]

export zmq-msg-alloc: command []
export zmq-msg-free: command [msg [handle!]]
export zmq-msg-init: command [msg [handle!]]
export zmq-msg-init-size: command [msg [handle!] size [integer!]]
export zmq-msg-init-data: command [msg [handle!] data [binary!]]
export zmq-msg-close: command [msg [handle!]]
export zmq-msg-data: command [msg [handle!]]
export zmq-msg-size: command [msg [handle!]]
;export zmq-msg-copy: command [msg-dest [handle!] msg-src [handle!]]
;export zmq-msg-move: command [msg-dest [handle!] msg-src [handle!]]

export zmq-socket: command [ctx [handle!] type [integer!]]
export zmq-close: command [socket [handle!]]
;;; @@ getsockopt, setsockopt
export zmq-bind: command [socket [handle!] endpoint [string!]]
export zmq-connect: command [socket [handle!] endpoint [string!]]
export zmq-send: command [socket [handle!] msg [handle!] flags [integer!]]
export zmq-recv: command [socket [handle!] msg [handle!] flags [integer!]]
;;; @@ poll?

export zmq-errno: command []
export zmq-strerror: command [errnum [integer!]]

export zmq-version: command []
