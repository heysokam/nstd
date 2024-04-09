#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# std dependencies
import std/os
import std/strformat
import std/strutils
from std/times import now, format
# n*std dependencies
import ../types as base
import ../cfg
import ../paths
# logger dependencies
import ./types as l

#_______________________________________
# Alternative Field access
#___________________
func key *(lvl :Log) :string=
  case lvl
  of None  : raise newException(LogError, cfg.Prefix&"Tried to get the key name for log level None")
  of Inf   : result = "Info"
  of Wrn   : result = "Warn"
  of Err   : result = "Error"
  of Fatal : result = "Fatal"
  of Dbg   : result = "Debug"
  of Trc   : result = "Trace"
  of All   : raise newException(LogError, cfg.Prefix&"Tried to get the key name for log level All")

#_______________________________________
# Files
#___________________
proc getDefaultFile *() :Path {.inline.}=  Path( os.getAppFilename().changeFileExt("log") )  # aka: /path/to/app/binary.log
  ## Returns the path that will be set by default when omitted.
#___________________
proc getFileHandle (file :Path; kind :l.Kind; toStderr :bool= false) :File=
  ## Returns the correct file handle for the logger kind.
  ## toStderr will be ignored if the kind is not a ConLogger
  case kind:
  of ConLogger:
    result = if toStderr: stderr else: stdout
  of FileLogger:
    if file == UndefinedPath: raise newException(LogError, &"{cfg.Prefix} Tried to initialize a FileLogger with an uninitialized Path.")
    result = file.string.open(mode = fmAppend)
#___________________
proc getPathFile *(file :Path; kind :l.Kind; toStderr :bool= false) :PathFile=
  result = PathFile(path: file, handle: file.getFileHandle(kind, toStderr), mode: fmAppend)

#_______________________________________
# Format Message
#_____________________________
# Message Data
# __________________
# Logging level  |  to quickly sort/filter messages into different buckets by urgency.
# Logger Name    |  to know where the message comes from.
# Date & Time    |  to correlate it with other events.
# Message Text   |  Actual information of the event. The rest is meta-data to find why this happened.
# Stack Trace    |  In case of error messages, a stack trace will help finding where the error was triggered.
#___________________
const Sep * = "|"
#___________________
proc getDateTime () :string=
  let d = times.now()
  result.add d.format("yyyy-MM-dd")
  result.add &" {Sep} "
  result.add d.format("HH:mm:ss:fff")
#___________________
const PattDate   * = "{getDateTime()}"
const PattLevel  * = "{level.key()}"
const PattName   * = "{logger.name}"
const PattMsg    * = "{msg}"
const PattTrace  * = "{getStackTrace()}"
#___________________
proc formatMsg *(logger :Logger; level :Log; args :varargs[string, `$`]) :string=
  ## Returns a string correctly formatted for the logger, level and args given.
  result = fmt"{logger.name} {Sep} {getDateTime()} {Sep} {level.key()} {Sep} {args.join()}"
  if level >= Log.Fatal: result.add( fmt" {Sep} {getStackTrace()}" )

