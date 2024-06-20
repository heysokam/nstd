#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
#  Contains code inspired by std/logging     |  MIT  :
#    (C) Copyright Andreas Rumpf, Dominik Picheta    :
#:____________________________________________________
# n*std dependencies
import ../types as base
import ../paths/types as paths


#_______________________________________
# Levels
#___________________
type Log  *{.pure.}= enum
  ## Log level of a message
  None  ## No levels active; nothing is logged
  Info  ## User: Information that users should be informed about.
  Wrn   ## Both: Impending problems that require some attention.
  Err   ## Both: Error conditions that the application can recover from.
  Dbg   ## Dev:  Debug Info. Anything associated with normal operation that devs need to know about.
  Fatal ## Both: Fatal errors that prevent the application from continuing.
  Trc   ## Dev:  Trace Info. Finest debug information. For when something is hard to find. TMI.
  All   ## Every log level
#___________________
type LogError * = object of CatchableError
  ## Raised when something goes wrong during logging.

#_______________________________________
# Callback prototypes
#___________________
type LogFunc * = proc (args: varargs[string, `$`]) :void
  ## Callback prototype for logging with levels that are defined in the function body
type LvlFunc * = proc (lvl :Log; args: varargs[string, `$`]) :void
  ## Callback prototype for logging with a specific level


#_______________________________________
# Logger Object
#___________________
type Kind * = enum ConLogger, FileLogger
type Logger * = ref object
  name      *:str        ## Format string to prepend to each log message
  threshold *:Log        ## Only messages that are at or below this threshold will be logged
  flushLvl  *:Log        ## Only messages that are at or below this threshold will be flushed immediately
  verbose   *:bool       ## TODO: Whether messages on this logger will be verbose or not
  file      *:PathHandle ## The wrapped file. Its handle will become stderr/stdout for the ConLogger kind
  case kind *:Kind
  of ConLogger  : discard
  of FileLogger : discard

