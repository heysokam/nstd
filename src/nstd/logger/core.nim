#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
#  Contains code inspired by std/logging     |  MIT  :
#    (C) Copyright Andreas Rumpf, Dominik Picheta    :
#:____________________________________________________
# std dependencies
import std/os
# n*std dependencies
import ../types as base
import ../markers
import ../time
# Logger dependencies
import ./types as l


var defLogger *:Logger= Logger(kind: ConLogger)

func new *(kind :l.Kind;
    prop :str;
  ) :Logger=
  result = Logger(kind: kind)
  case kind
  of ConLogger  : discard
  of FileLogger : discard
  discard#todo()

func newConLogger *() :Logger= Logger(kind: ConLogger)
  ## Creates a new console logger.
  ## Messages are written to stdout, unless useStderr is true.

func setDefaultLogger *(logger :Logger) :void= discard#todo()
func getDefaultLogger *() :Logger= discard#todo()

template trc *(args :varargs[string, `$`]) :void=  defLogger.log(Log.Trc, args)  ## Logs a trace message to all registered handlers.
template dbg *(args :varargs[string, `$`]) :void=  defLogger.log(Log.Dbg, args)  ## Logs a debug message to all registered handlers.
template inf *(args :varargs[string, `$`]) :void=  defLogger.log(Log.Inf, args)  ## Logs info msg to all registered handlers.
template wrn *(args :varargs[string, `$`]) :void=  defLogger.log(Log.Wrn, args)  ## Logs a warning msg to all registered handlers.
template err *(args :varargs[string, `$`]) :void=  defLogger.log(Log.Err, args)  ## Logs an error msg to all registered handlers.


##[ TODO ]#_______________________________________
# const newConLogger * = std.newConsoleLogger
export std.newFileLogger  ## Creates a new FileLogger that logs to the given filename or File handle.
#___________________
# Logging
#___________________
export std.log
export std.fatal  ## Logs a fatal error message to all registered handlers.
proc noLog *(args :varargs[string, `$`]) :void= discard
]##

