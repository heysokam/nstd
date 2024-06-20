#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# @deps std
import std/os
from std/times import now, format
# @deps n*std
import ../types as base
import ../cfg
import ../errors
import ../paths
import ../strings
# @deps n*std.logger
import ./types as l


#_______________________________________
# @section Alternative Field access
#___________________
func key *(lvl :Log) :str=
  case lvl
  of None  : LogError.trigger "Tried to get the key name for log level None"
  of Info  : result = "Info"
  of Wrn   : result = "Warn"
  of Err   : result = "Error"
  of Fatal : result = "Fatal"
  of Dbg   : result = "Debug"
  of Trc   : result = "Trace"
  of All   : LogError.trigger "Tried to get the key name for log level All"


#_______________________________________
# @section Files
#___________________
proc getDefaultFile *() :Path {.inline.}=
  ## @descr Returns the path that will be set by default when omitted.
  let (dir, name, _) = os.getAppFilename().splitFile
  result = Path.new(dir, name&".log")  # aka: /path/to/app/binary.log
#___________________
proc getFileHandle (file :Path; kind :l.Kind; toStderr :bool= false) :File=
  ## @descr
  ##  Returns the correct file handle for the logger kind.
  ##  If {@arg toStderr} is true, the console logger will output to {@link stderr}
  ## @note {@arg toStderr} will be ignored if the kind is not a ConLogger
  case kind:
  of ConLogger:
    result = if toStderr: stderr else: stdout
  of FileLogger:
    if file == UndefinedPath: LogError.trigger "Tried to initialize a FileLogger with an uninitialized Path."
    result = file.toStr.open(mode = fmAppend)
#___________________
proc getPathFile *(file :Path; kind :l.Kind; toStderr :bool= false) :PathHandle=
  result = PathHandle(file: file, handle: file.getFileHandle(kind, toStderr), mode: fmAppend)


#_______________________________________
# @section Format Message
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

