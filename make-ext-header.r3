REBOL [
    title: "Generates a C header for R3 extensions from a REBOL specficiation"
    author: "Andreas Bolka"
    rights: {
        Copyright (C) 2011 Andreas Bolka <a AT bolka DOT at>
        Licensed under the terms of the Apache License, Version 2.0
    }
]

to-c-name: funct [
    {Convert a REBOL name to a C name by replacing everything not in a-zA-z0-9_
    with an underscore.}
    rebol-name [word!]
] [
    valid-c-chars: charset [#"a" - #"z" #"A" - #"Z" #"0" - #"9" #"_"]
    replace/all form rebol-name negate valid-c-chars #"_"
]

;; read the REBOL source
filename: to-file first system/options/args
source: load/all filename
header: take/part source 2

;; extract all set-words immediately followed by COMMAND
commands: collect-words/set source
remove-each command commands ['command != select source to-set-word command]

;; pass thru the REBOL header, along with an auto-generation warning
prin rejoin [
    "/*" newline
    "This file was automatically generated:" newline
    newline
    "    Source file:     " filename newline
    "    Source date:     " modified? filename newline
    "    Generation date: " now newline
    newline
    "The REBOL 3 header of the source file follows:" newline
    newline
    mold/only header
    newline
    "*/" newline
    newline
]

;; generate command function declarations
foreach command commands [
    print rejoin [
        {static int cmd_} to-c-name command {(RXIFRM *frm, void *data);}
    ]
]

;; generate an array mapping command number to function pointer
print rejoin [{static const int command_count = } length? commands {;}]
print {typedef int (RXICMD)(RXIFRM*, void*);}
print {static RXICMD * const command_block[] = ^{}
foreach command commands [
    print rejoin [{    &cmd_} to-c-name command {,}]
]
print {^};}

;; generate the init block wrapping the REBOL source in a C string (escaping ")
print {static const char init_block[] =}
foreach line read/lines to-file first system/options/args [
    trim/tail line
    replace/all line {"} {\"}
    print rejoin [{    "} line {\n"}]
]
print {;}
