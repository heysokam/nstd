#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/strformat
# External dependencies
# TODO: logit or other alternative
# Module dependencies
import ./cfg
import ./types

## TODO: Use std/terminal  colors !!

#______________________________
# Logging
proc logP (lvl :LogLevel; msg :string) :void=
  ## Internal use. Call log instead
  if lvl <= cfg.logLvl: echo &"{msg}" else: discard

#______________________________
proc log *(lvl :LogLevel; msg :string) :void=
  ## Log with level selection
  case lvl
  of NoLog:  discard
  of Info:   logP Info,  &":: {msg}"
  of Warn:   logP Warn,  &"WRN:: {msg}"
  of Error:  logP Error, &"ERR:: {msg}"
  of Trace:  logP Trace, &"TRC:|| {msg}"
  else:      logP Error, &"UNDEF:: {msg}" 
#______________________________
proc log *(msg :string) :void= log Info, &"{msg}"
  ## Shorthand: Info.log "message"
#______________________________
