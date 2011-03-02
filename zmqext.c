/*
** zmqext -- A low-level ØMQ extension for REBOL 3
**
** Copyright (C) 2011 Andreas Bolka <a AT bolka DOT at>
** Licensed under the terms of the Apache License, Version 2.0.
**
** The zmqext REBOL 3 extension uses the ØMQ library, the use of which is
** granted under the terms of the GNU Lesser General Public License (LGPL),
** Version 3.
*/

#include <stdlib.h>
#include <string.h>
#include <zmq.h>

#include "reb-host.h"

#include "zmqext.h"

// --- RX interface ---

RL_LIB *RL;

const char *RX_Init(int opts, RL_LIB *lib) {
    RL = lib;
    return init_block;
}

int RX_Call(int cmd, RXIFRM *frm, void *data) {
    if (cmd < command_count)
        return (command_block[cmd])(frm, data);
    return RXR_NO_COMMAND;
}

// --- helpers ---

REBSER *rlu_strncpy(REBSER *dest, const char *source, size_t n) {
    int i;
    for (i = 0; i < n; ++i) {
        RL_SET_CHAR(dest, i, source[i]);
    }
    return dest;
}

REBSER *rlu_make_string(const char *source) {
    size_t size = strlen(source);
    return rlu_strncpy(RL_MAKE_STRING(size, FALSE), source, size);
}

char *rlu_copy_binary(const RXIARG binary, size_t *size) {
    REBSER *binary_series = binary.series;
    size_t binary_head = binary.index;
    size_t binary_tail = RL_SERIES(binary_series, RXI_SER_TAIL);
    char *binary_data = (char*)RL_SERIES(binary_series, RXI_SER_DATA);
    char *result;

    *size = binary_tail - binary_head;
    result = (char*)malloc(*size); // @@ check
    memcpy(result, binary_data + binary_head, *size);

    return result;
}

char *rlu_copy_string(const RXIARG string) {
    // @@ should use RL_GET_STRING or something. won't work for unicode strings
    REBSER *string_series = string.series;
    size_t string_head = string.index;
    size_t string_tail = RL_SERIES(string_series, RXI_SER_TAIL);
    size_t string_size = string_tail - string_head;
    char *string_data = (char*)RL_SERIES(string_series, RXI_SER_DATA);
    char *result;

    result = (char*)malloc(string_size + 1); // @@ check
    result[string_size] = 0;
    memcpy(result, string_data + string_head, string_size);

    return result;
}

// --- commands ---

static int cmd_zmq_init(RXIFRM *frm, void *data) {
    int io_threads = RXA_INT32(frm, 1);
    void *ctx = zmq_init(io_threads);
    RXA_HANDLE(frm, 1) = ctx;
    RXA_TYPE(frm, 1) = RXT_HANDLE;
    return RXR_VALUE;
}

static int cmd_zmq_term(RXIFRM *frm, void *data) {
    void *ctx = RXA_HANDLE(frm, 1);
    int rc = zmq_term(ctx);
    RXA_INT64(frm, 1) = rc;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_msg_alloc(RXIFRM *frm, void *data) {
    zmq_msg_t *msg = (zmq_msg_t*)malloc(sizeof(zmq_msg_t)); // @@ check
    RXA_HANDLE(frm, 1) = msg;
    RXA_TYPE(frm, 1) = RXT_HANDLE;
    return RXR_VALUE;
}

static int cmd_zmq_msg_free(RXIFRM *frm, void *data) {
    zmq_msg_t *msg = (zmq_msg_t*)RXA_HANDLE(frm, 1);
    free(msg);
    return RXR_UNSET;
}

static int cmd_zmq_msg_init(RXIFRM *frm, void *data) {
    zmq_msg_t *msg = (zmq_msg_t*)RXA_HANDLE(frm, 1);
    RXA_INT64(frm, 1) = zmq_msg_init(msg);
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_msg_init_size(RXIFRM *frm, void *data) {
    zmq_msg_t *msg = (zmq_msg_t*)RXA_HANDLE(frm, 1);
    size_t msg_size = RXA_INT32(frm, 2);
    int rc = zmq_msg_init_size(msg, msg_size);
    RXA_INT64(frm, 1) = rc;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

void free_msg_data(void *data, void *hint) {
    free(data);
}

static int cmd_zmq_msg_init_data(RXIFRM *frm, void *data) {
    zmq_msg_t *msg = RXA_HANDLE(frm, 1);
    RXIARG binary = RXA_ARG(frm, 2);
    size_t msg_size;
    char *msg_data = rlu_copy_binary(binary, &msg_size);
    int rc = zmq_msg_init_data(msg, msg_data, msg_size, &free_msg_data, NULL);
    RXA_INT64(frm, 1) = rc;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_msg_close(RXIFRM *frm, void *data) {
    zmq_msg_t *msg = (zmq_msg_t*)RXA_HANDLE(frm, 1);
    RXA_INT64(frm, 1) = zmq_msg_close(msg);
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_msg_data(RXIFRM *frm, void *data) {
    zmq_msg_t *msg = (zmq_msg_t*)RXA_HANDLE(frm, 1);
    size_t msg_size = zmq_msg_size(msg);
    void *msg_data = zmq_msg_data(msg);
    REBSER *result = RL_MAKE_STRING(msg_size, FALSE);
    RXA_SERIES(frm, 1) = rlu_strncpy(result, msg_data, msg_size);
    RXA_INDEX(frm, 1) = 0;
    RXA_TYPE(frm, 1) = RXT_BINARY;
    return RXR_VALUE;
}

static int cmd_zmq_msg_size(RXIFRM *frm, void *data) {
    zmq_msg_t *msg = (zmq_msg_t*)RXA_HANDLE(frm, 1);
    size_t msg_size = zmq_msg_size(msg);
    RXA_INT64(frm, 1) = msg_size;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_socket(RXIFRM *frm, void *data) {
    void *ctx = RXA_HANDLE(frm, 1);
    int type = RXA_INT32(frm, 2);
    void *socket = zmq_socket(ctx, type);
    RXA_HANDLE(frm, 1) = socket;
    RXA_TYPE(frm, 1) = RXT_HANDLE;
    return RXR_VALUE;
}

static int cmd_zmq_close(RXIFRM *frm, void *data) {
    void *socket = RXA_HANDLE(frm, 1);
    int rc = zmq_close(socket);
    RXA_INT64(frm, 1) = rc;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_bind(RXIFRM *frm, void *data) {
    void *socket = RXA_HANDLE(frm, 1);
    RXIARG endpoint = RXA_ARG(frm, 2);
    char *str = rlu_copy_string(endpoint);
    int rc = zmq_bind(socket, str);
    free(str);
    RXA_INT64(frm, 1) = rc;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_connect(RXIFRM *frm, void *data) {
    void *socket = RXA_HANDLE(frm, 1);
    RXIARG endpoint = RXA_ARG(frm, 2);
    char *str = rlu_copy_string(endpoint);
    int rc = zmq_connect(socket, str);
    free(str);
    RXA_INT64(frm, 1) = rc;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_send(RXIFRM *frm, void *data) {
    void *socket = RXA_HANDLE(frm, 1);
    zmq_msg_t *msg = RXA_HANDLE(frm, 2);
    int flags = RXA_INT32(frm, 3);
    int rc = zmq_send(socket, msg, flags);
    RXA_INT64(frm, 1) = rc;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_recv(RXIFRM *frm, void *data) {
    void *socket = RXA_HANDLE(frm, 1);
    zmq_msg_t *msg = RXA_HANDLE(frm, 2);
    int flags = RXA_INT32(frm, 3);
    int rc = zmq_recv(socket, msg, flags);
    RXA_INT64(frm, 1) = rc;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_errno(RXIFRM *frm, void *data) {
    int errnum = zmq_errno();
    RXA_INT64(frm, 1) = errnum;
    RXA_TYPE(frm, 1) = RXT_INTEGER;
    return RXR_VALUE;
}

static int cmd_zmq_strerror(RXIFRM *frm, void *data) {
    int errnum = RXA_INT32(frm, 1);
    const char *errmsg = zmq_strerror(errnum);
    RXA_SERIES(frm, 1) = rlu_make_string(errmsg);
    RXA_INDEX(frm, 1) = 0;
    RXA_TYPE(frm, 1) = RXT_STRING;
    return RXR_VALUE;
}

static int cmd_zmq_version(RXIFRM *frm, void *data) {
    int major, minor, patch;
    zmq_version(&major, &minor, &patch);
    RXA_TUPLE(frm, 1)[0] = 3;       // @@ HACK! need RL tuple helpers
    RXA_TUPLE(frm, 1)[1] = major;
    RXA_TUPLE(frm, 1)[2] = minor;
    RXA_TUPLE(frm, 1)[3] = patch;
    RXA_TYPE(frm, 1) = RXT_TUPLE;
    return RXR_VALUE;
}
