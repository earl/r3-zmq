REBOL [
    title: "0MQ helper functions for examples"
    author: ["Gregg Irwin" "Andreas Bolka"]
    name: helpers
    type: module
    exports: [s-recv s-send]
]

s-recv: funct [
    "Receive message from socket and convert the message data to a string!"
    socket [handle!] "0MQ socket"
    /binary "Return the binary! (don't convert to string!)"
] [
    msg: zmq-msg-alloc
    zmq-msg-init msg

    zmq-recv socket msg 0 ;; 0 == no recv flags

    ;; Copy binary data from message.
    data: zmq-msg-data msg

    zmq-msg-close msg
    zmq-msg-free msg

    either binary [data] [to string! data]
]

s-send: funct [
    "Copy a string! (or binary!) into a 0MQ message and send it to socket"
    socket [handle!] "0MQ socket"
    data [string! binary!]
] [
    msg: zmq-msg-alloc
    zmq-msg-init-data msg to binary! data

    rc: zmq-send socket msg 0 ;; 0 == no send flags

    zmq-msg-close msg
    zmq-msg-free msg

    ;; rc will be -1 if an error occurs, return the exact error code in this
    ;; case.
    either negative? rc [zmq-errno] [rc]
]
