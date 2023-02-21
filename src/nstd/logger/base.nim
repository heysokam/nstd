#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/strformat
# External dependencies
# TODO: loggit or other alternative
# Engine dependencies
import ../../cfg
# Module dependencies
import ./types

## TODO: Use std/terminal  colors !!

#______________________________
# Logging
proc loggP (lvl :int; msg :string) :void=
  ## Internal use. Call logg instead
  if lvl <= cfg.logLvl: echo &"{msg}" else: discard

#______________________________
proc logg *(lvl :int; msg :string) :void=  # With log level selection
  case lvl
  of nolog:  discard
  of info:   loggP info,  &":: {msg}"
  of warn:   loggP warn,  &"WRN:: {msg}"
  of error:  loggP error, &"ERR:: {msg}"
  of trace:  loggP trace, &"TRC:|| {msg}"
  else:      loggP error, &"UNDEF:: {msg}" 
#______________________________
proc logg *(msg :string) :void= logg info, &"{msg}"  # Shorthand: logg info, "message"
#______________________________
