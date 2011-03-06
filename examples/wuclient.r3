REBOL [author: "Andreas Bolka" date: 2011-03-06]

import %extload.r3
import %zmqext.rx

;; 0MQ socket to talk to server
ctx: zmq-init 1
subscriber: zmq-socket ctx zmq-constants/sub
zmq-connect subscriber "tcp://localhost:5556"

;; Subscribe to a zipcode, default to NYC (10001)
filter: to-integer any [attempt [first system/options/args] 10001]
zmq-setsockopt-binary subscriber zmq-constants/subscribe to-binary mold filter

;; Process 100 updates
total-temp: 0
msg: zmq-msg-alloc
loop 100 [
    zmq-msg-init msg
    zmq-recv subscriber msg 0
    set [zipcode temperature rel-humidity] load zmq-msg-data msg
    zmq-msg-close msg
    total-temp: total-temp + temperature
]
zmq-msg-free msg
print ["Average temperature for zipcode" filter "was" (total-temp / 100) "°F"]

;; Shut down
zmq-close subscriber
zmq-term ctx
