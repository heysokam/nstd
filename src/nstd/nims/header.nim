#!/usr/bin/env -S nim --hints:off
let sMode= "v"    ; if sMode == "w": mode= Scriptmode.Whatif elif smode == "s": mode= ScriptMode.Silent elif smode == "v": mode= ScriptMode.Verbose else: discard #   WhatIf: Do not run commands, instead just echo what would have been done.

#_________________________________________________
# Copy paste to the top of new nims files         |
# Used to control the behavior of file io procs,  |
# and configure the file in unix as a script.     |
#_________________________________________________|
