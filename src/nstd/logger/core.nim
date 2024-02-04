#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
#  Contains code inspired by std/logging     |  MIT  :
#    (C) Copyright Andreas Rumpf, Dominik Picheta    :
#:____________________________________________________
# n*std dependencies
import ../types as base
import ../paths
import ../files
# Logger dependencies
import ./types as l
import ./cfg
import ./helpers


#_______________________________________
# @section Constructors
#___________________
proc new *(kind :l.Kind;
    name      : str;
    threshold : Log  = DefThreshold;
    flushLvl  : Log  = DefFlushLvl;
    verbose   : bool = DefVerbose;
    toStderr  : bool = false;
    file      : Path = DefPath;
  ) :Logger=
  ## Internal use  -> Creates a new Logger object of the given kind.
  ## Properties will get their default values when omitted.
  ## Properties relevant only to specific logger types will just be ignored.
  result = Logger(kind: kind,
    name      : name,
    threshold : threshold,
    flushLvl  : flushLvl,
    verbose   : verbose,
    file      : file.getPathFile(kind, toStderr),
    ) # << Logger( ... )
#___________________
proc newConLogger *(
    name      : str;
    threshold : Log  = DefThreshold;
    flushLvl  : Log  = DefFlushLvl;
    verbose   : bool = DefVerbose;
    toStderr  : bool = false;
  ) :Logger=
  ## Creates a new console logger.
  ## if toStderr is true, messages are written to stderr, or stdout if false.
  result = ConLogger.new(
    name      = name,
    threshold = threshold,
    flushLvl  = flushLvl,
    verbose   = verbose,
    toStderr  = toStderr,
    file      = UndefinedPath,
    ) # << ConLogger.new( ... )
#___________________
proc newFileLogger *(
    name      : str;
    threshold : Log  = DefThreshold;
    flushLvl  : Log  = DefFlushLvl;
    verbose   : bool = DefVerbose;
    file      : Path = DefPath;
  ) :Logger=
  ## Creates a new FileLogger that logs to the given filename.
  ## The file is kept open during the lifetime of the logger.
  ## Contents to the file will be appended.
  ## Call logger.clear() if you need to wipe its contents.
  result = FileLogger.new(
    name      = name,
    threshold = threshold,
    flushLvl  = flushLvl,
    verbose   = verbose,
    file      = file,
    ) # << ConLogger.new( ... )

#_______________________________________
# @section Logger Control
#___________________
proc log*(
    logger : Logger;
    level  : Log;
    flush  : bool;
    args   : varargs[string, `$`];
  ) :void=
  ## Logs a message of the given level to the input logger.
  ## Note: Requires calling with `flush = on/off` to be able to access this overload
  if level > logger.threshold: return
  try:
    logger.file.handle.writeLine( logger.formatMsg(level, args) )
    if flush or level <= logger.flushLvl: logger.file.handle.flushFile()
  except IOError: discard
#____________________
proc log*(
    logger : Logger;
    level  : Log;
    args   : varargs[string, `$`];
  ) :void=
  ## Logs a message of the given level to the input logger.
  ## Does nothing if the logger.threshold configured is below the log level sent to this function.
  ## Does not force-flush, unless the level meets the logger's criteria. Use `flush = true` to call the force-flushing overload.
  logger.log(level, flush = false, args)
#____________________
template trc   *(logger :Logger; args :varargs[string, `$`]) :void=  logger.log(Log.Trc,   args)  ## Logs a trace message with the given logger.
template dbg   *(logger :Logger; args :varargs[string, `$`]) :void=  logger.log(Log.Dbg,   args)  ## Logs a debug message with the given logger.
template inf   *(logger :Logger; args :varargs[string, `$`]) :void=  logger.log(Log.Inf,   args)  ## Logs info msg with the given logger.
template wrn   *(logger :Logger; args :varargs[string, `$`]) :void=  logger.log(Log.Wrn,   args)  ## Logs a warning msg with the given logger.
template err   *(logger :Logger; args :varargs[string, `$`]) :void=  logger.log(Log.Err,   args)  ## Logs an error msg with the given logger.
template fatal *(logger :Logger; args :varargs[string, `$`]) :void=  logger.log(Log.Fatal, args)  ## Logs a fatal error message with the given logger.
template noLog *(logger :Logger; args :varargs[string, `$`]) :void=  discard

#____________________
proc clear *(logger :Logger) :void=
  ## Deletes the contents of the given logger's file.
  case logger.kind
  of ConLogger  : return
  of FileLogger : logger.file.erase()

#_______________________________________
# @section Internal State Logger
#___________________
var defLogger {.threadvar.} :Logger
  ## Internal default (per thread) logger.
  ## Defaults to a Console Logger (stdout) when initialized with the `nstd/logger/core.init()` function
  ##
  ## Only for ergonomics when logging in a simple way.
  ## Should always prefer storing your loggers explicitely, and calling them directly.
#_______________________________________
proc setDefaultLogger *(logger :Logger) :void=  defLogger = logger
  ## Sets the internal default (per thread) logger.
  ##
  ## Only for ergonomics when logging in a simple way.
  ## Should always prefer storing your loggers explicitely, and calling them directly.
proc getDefaultLogger *() :Logger=  defLogger
  ## Returns the internal default (per thread) logger.
  ##
  ## Only for ergonomics when logging in a simple way.
  ## Should always prefer storing your loggers explicitely, and calling them directly.
proc init *(
    name      : string = cfg.Prefix&" DefaultLogger",
    threshold : Log    = DefThreshold;
    flushLvl  : Log    = DefFlushLvl;
    verbose   : bool   = DefVerbose;
    toStderr  : bool   = false;
  ) :void=
  ## Sets the internal default (per thread) logger with default values.
  ## Either this function, or `setDefaultLogger`, must be run once for each thread.
  ## All arguments can be omitted, and will use their default values.
  ## Can only initialize a Console Logger.
  ## Use `setDefaultLogger` if you prefer to use other logger type instead.
  ##
  ## Only for ergonomics when logging in a simple way.
  ## Should always prefer storing your loggers explicitely, and calling them directly.
  defLogger = ConLogger.new(
    name      = name,
    threshold = threshold,
    flushLvl  = flushLvl,
    verbose   = verbose,
    toStderr  = toStderr,
    ) # << Logger( ... )

#_______________________________________
proc ensureInit () :void {.inline.}=
  if defLogger.isNil: core.init()
template trc   *(args :varargs[string, `$`]) :void=  ensureInit(); defLogger.log(Log.Trc,   args)  ## @descr Logs a trace message with the default (per thread) logger.
template dbg   *(args :varargs[string, `$`]) :void=  ensureInit(); defLogger.log(Log.Dbg,   args)  ## @descr Logs a debug message with the default (per thread) logger.
template info  *(args :varargs[string, `$`]) :void=  ensureInit(); defLogger.log(Log.Inf,   args)  ## @descr Logs info msg with the default (per thread) logger.
template warn  *(args :varargs[string, `$`]) :void=  ensureInit(); defLogger.log(Log.Wrn,   args)  ## @descr Logs a warning msg with the default (per thread) logger.
template err   *(args :varargs[string, `$`]) :void=  ensureInit(); defLogger.log(Log.Err,   args)  ## @descr Logs an error msg with the default (per thread) logger.
template fatal *(args :varargs[string, `$`]) :void=  ensureInit(); defLogger.log(Log.Fatal, args)  ## @descr Logs a fatal error message with the default (per thread) logger.
template noLog *(args :varargs[string, `$`]) :void=  discard

##[ IDEAS ]#_______________________________________
const PattMsgID  * = ""
# Message ID     |  to quickly find the code responsible for the message
#                   unique to each type of message, so we can do a text search and find the code where it comes from.
const PattThread * = ""
# Thread name    |  to quickly deduce information
#                   (e.g. “it happened in the scheduler thread, so it cannot have been triggered by an incoming user request”).
]##

