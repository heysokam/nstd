#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
#  Contains modified code from std/logging   |  MIT  :
#    (C) Copyright Andreas Rumpf, Dominik Picheta    :
#:____________________________________________________
# n*std dependencies
import ../types as base
import ../cfg


#_______________________________________
# Levels
#___________________
type Log  *{.pure.}= enum
  None  ## No levels active; nothing is logged
  Inf   ## User: Information that users should be informed about.
  Wrn   ## Both: Impending problems that require some attention.
  Err   ## Both: Error conditions that the application can recover from.
  Dbg   ## Dev:  Debug Info. Anything associated with normal operation that devs need to know about.
  Trc   ## Dev:  Trace Info. Finest debug information. For when something is hard to find. TMI.
  Fatal ## Both: Fatal errors that prevent the application from continuing.
  All   ## Every log level
#___________________
type LogError * = object of CatchableError
  ## Raised when something goes wrong during logging.
#___________________
func key *(l :Log) :string=
  case l
  of None  : raise newException(LogError, cfg.nstdPrefix&"Tried to get the key name for log level None")
  of Inf   : result = "Info"
  of Wrn   : result = "Warn"
  of Err   : result = "Error"
  of Fatal : result = "Fatal"
  of Dbg   : result = "Debug"
  of Trc   : result = "Trace"
  of All   : raise newException(LogError, cfg.nstdPrefix&"Tried to get the key name for log level All")

#_______________________________________
# Callback prototypes
#___________________
type LogFunc * = proc (args: varargs[string, `$`]) :void
  ## Callback prototype for logging with levels that are defined in the function body
type LvlFunc * = proc (lvl :Log; args: varargs[string, `$`]) :void
  ## Callback prototype for logging with a specific level


#_______________________________________
# Default Configuration
#___________________
const nstdLogFormat   {.strdefine.}= "[ndk]"
const DefThreshold    = Log.All
const nstdLogFlushAll {.booldefine.}= off
const DefFlushLvl     = when nstdLogFlushAll: Log.All else: Log.Fatal

#_______________________________________
# Logger Object
#___________________
type Kind * = enum ConLogger, FileLogger
type Logger * = ref object
  fmt       *:str = nstdLogFormat     ## Format string to prepend to each log message
  threshold *:Log = DefThreshold  ## Only messages that are at or below this threshold will be logged
  flushLvl  *:Log = DefFlushLvl   ## Only messages that are at or above this threshold will be flushed immediately
  verbose   *:bool                ## Whether messages on this logger will be verbose or not
  case kind *:Kind
  of ConLogger:
    toStderr *:bool  ## If true, writes to stderr; otherwise, writes to stdout
  of FileLogger:
    file  *:File  ## The wrapped file

