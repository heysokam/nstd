#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# Aliases for the std/logging module    |
# Very likely to be removed forever     |
#_______________________________________|
# std dependencies
from std/logging as std import nil


#_______________________________________
# Logger Types
#_____________________________
type BaseLogger * = std.Logger
  ## The abstract base type of all loggers.
  ## Custom loggers should inherit from this type, and provide an implementation of:
  ##   method log(logger: Logger; level: Level; args: varargs[string, `$`]) {.base.}
  ## levelThreshold  :Level   ## Only messages that are at or above this threshold will be logged
  ## fmtStr          :string  ## Format string to prepend to each log message; defaultFmtStr is the default
#_____________________________
# Console
#___________________
type  ConLogger      * = std.ConsoleLogger
  ## A logger that writes log messages to the console.
  ## flushThreshold  :Level ## Only messages that are at or above this threshold will be flushed immediately
  ## useStderr       :bool  ## If true, writes to stderr; otherwise, writes to stdout
const newConLogger   * = std.newConsoleLogger
  ## Creates a new console logger.
  ## Messages are written to stdout, unless useStderr is true.
#_____________________________
# File
#___________________
type   FileLogger    * = std.FileLogger
  ## A logger that writes log messages to a file.
  ## file            :File  ## The wrapped file
  ## flushThreshold  :Level ## Only messages that are at or above this threshold will be flushed immediately
export std.newFileLogger  ## Creates a new FileLogger that logs to the given filename or File handle.
#_____________________________
# Rolling File
#___________________
type  RollLogger     * = std.RollingFileLogger
  ## A logger that writes log messages to a file while performing log rotation.
  ## maxLines        :int      # maximum number of lines
  ## curLine         :int
  ## baseName        :string   # initial filename
  ## baseMode        :FileMode # initial file mode
  ## logFiles        :int      # how many log files already created, e.g. basename.1, basename.2...
  ## bufSize         :int      # size of output buffer (-1: use system defaults, 0: unbuffered, >0: fixed buffer size)
const newRollLogger  * = std.newRollingFileLogger
  ## Creates a new RollLogger, that logs to the given filename.
  ## Once the current log file being written to contains `maxLines` lines, 
  ## a new file will be created, and the old will be renamed.

#_______________________________________
# Levels
#___________________
type Log  *{.pure.}= enum
  ## Individual loggers have a ``levelThreshold`` field that filters out any messages with a level lower than the threshold.
  ## There is also a global filter that applies to all log messages, and it can be changed using setLogFilter.
  ## NOTE: Three levels are renamed, but use the same underlying values from std/logging:
  ##   std.Debug is now Trace, std.Info is now Debug, and std.Notice is now Info
  ##   We assume that Notices will be called in some other way that is not through logging (like UI)
  All     = std.lvlAll    ## Every log level
  Trc     = std.lvlDebug  ## Dev:  Trace Info. Finest debug information. For when something is hard to find. TMI.
  Dbg     = std.lvlInfo   ## Dev:  Debug Info. Anything associated with normal operation that devs need to know about.
  Inf     = std.lvlNotice ## User: Information that users should be informed about.
  Wrn     = std.lvlWarn   ## Both: Impending problems that require some attention.
  Err     = std.lvlError  ## Both: Error conditions that the application can recover from.
  Fatal   = std.lvlFatal  ## Both: Fatal errors that prevent the application from continuing.
  None    = std.lvlNone   ## No levels active; nothing is logged
converter toStd *(l :Log) :std.Level=  std.Level(l)


#_______________________________________
# State management
#___________________
export std.addHandler   ## Adds a logger to the list of registered handlers.
export std.getHandlers  ## Returns a seq of all the registered handlers.
const  getFilter   * = std.getLogFilter     ## Gets the global log filter.
const  setFilter   * = std.setLogFilter     ## Sets the global log filter.
const  defFilename * = std.defaultFilename  ## Returns the filename that is used by default when naming log files.

#_______________________________________
# Logging
#___________________
export std.log
template trc *(args :varargs[string, `$`]) :void=  std.log(Log.Trc.toStd, args)  ## Logs a trace message to all registered handlers.
template dbg *(args :varargs[string, `$`]) :void=  std.log(Log.Dbg.toStd, args)  ## Logs a debug message to all registered handlers.
template inf *(args :varargs[string, `$`]) :void=  std.log(Log.Inf.toStd, args)  ## Logs info msg to all registered handlers.
template wrn *(args :varargs[string, `$`]) :void=  std.log(Log.Wrn.toStd, args)  ## Logs a warning msg to all registered handlers.
template err *(args :varargs[string, `$`]) :void=  std.log(Log.Err.toStd, args)  ## Logs an error msg to all registered handlers.
export std.fatal  ## Logs a fatal error message to all registered handlers.

