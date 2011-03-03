REBOL [author: "Andreas Bolka" date: 2011-03-02]

import %extload.r3
import %zmqext.rx

ctx: zmq-init 1
socket: zmq-socket ctx zmq-constants/req
zmq-connect socket "tcp://localhost:5555"

msg: zmq-msg-alloc
repeat i 10 [
    ;; Sending request to server
    print ["Sending request" i "..."]
    zmq-msg-init-data msg to-binary "Hello"
    zmq-send socket msg 0
    zmq-msg-close msg

    ;; Waiting for reply
    zmq-msg-init msg
    zmq-recv socket msg 0
    print ["Received reply" i "[" to-string zmq-msg-data msg "]"]
    zmq-msg-close msg
]
zmq-msg-free msg
zmq-close socket
zmq-term ctx
