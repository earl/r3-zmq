REBOL [author: "Andreas Bolka" date: 2011-03-06]

import %extload.r3
import %zmqext.rx

;; 0MQ socket to talk to clients
ctx: zmq-init 1
publisher: zmq-socket ctx zmq-constants/pub
zmq-bind publisher "tcp://*:5556"
zmq-bind publisher "ipc://weather.ipc"

;; Initialise random number generator
random/seed now/precise

;; Send updates (in batches, and measure how long it takes to complete a batch)
msg: zmq-msg-alloc
batch-size: 1'000'000
start-time: stats/timer
forever [
    batch-time: dt [
        loop batch-size [
            ;; Generate some random values
            zipcode: random 100'000
            temperature: (random 215) - 80 ;; °F
            rel-humidity: (random 50) + 10

            ;; Send update to all subscribers
            weather: to-binary remold/only [zipcode temperature rel-humidity]

            zmq-msg-init-data msg to-binary weather
            zmq-send publisher msg 0
            zmq-msg-close msg
        ]
    ]
    print [
        batch-size "messages sent in" batch-time "-"
        (batch-size * (00:00:01 / batch-time)) "msgs/sec"
    ]
]
;zmq-msg-free msg
;zmq-close publisher
;zmq-term ctx
