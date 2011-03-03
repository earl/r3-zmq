REBOL [author: "Andreas Bolka" date: 2011-03-02]

import %extload.r3
import %zmqext.rx

ctx: zmq-init 1
socket: zmq-socket ctx zmq-constants/rep
zmq-bind socket "tcp://*:5555"

msg: zmq-msg-alloc
forever [
    ;; Wait for next request from client
    zmq-msg-init msg
    zmq-recv socket msg 0
    print ["Received request:" to-string zmq-msg-data msg]
    zmq-msg-close msg

    wait 1 ;; Do some 'work'

    ;; Send reply back to client
    zmq-msg-init-data msg to-binary "World"
    zmq-send socket msg 0
    zmq-msg-close msg
]
;zmq-msg-free msg
;zmq-close socket
;zmq-term ctx
