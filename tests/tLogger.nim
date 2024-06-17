#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
import std/unittest
# @deps n*std
import nstd
# Specific for this test
import std/os
import std/strformat
import std/times
import nstd/logger/helpers



#____________________________________________________
test nstd.Prefix&" Logger: Types":
  check nstd.LogFunc is proc (args: varargs[string, `$`]) :void
  check nstd.LvlFunc is proc (lvl :Log; args: varargs[string, `$`]) :void
  check nstd.Log.high.ord == 8-1  # Panic if we added a level but didn't make a test for it

#____________________________________________________
test nstd.Prefix&" Logger: Constructors":
  let verb = when defined(release) or defined(danger): false elif defined(debug): true else: true
  # Console Logger with Defaults
  let con = newConLogger(currentSourcePath().lastPathPart().changeFileExt("")&"_conLogger")
  check con.name        == "tLogger_conLogger"
  check con.kind        == logger.Kind.ConLogger
  check con.threshold   == Log.All  # might fail if cfg.flushAll is changed for tests
  check con.flushLvl    == Log.Fatal
  check con.verbose     == verb
  check con.file.path   == UndefinedPath
  check con.file.mode   == fmAppend
  check con.file.handle == stdout
  # File Logger with Defaults
  let file = newFileLogger(currentSourcePath().lastPathPart().changeFileExt("")&"_fileLogger")
  check file.name        == "tLogger_fileLogger"
  check file.kind        == logger.Kind.FileLogger
  check file.threshold   == Log.All  # might fail if cfg.flushAll is changed for tests
  check file.flushLvl    == Log.Fatal
  check file.verbose     == verb
  check file.file.path   == helpers.getDefaultFile()
  check file.file.mode   == fmAppend
  check file.file.handle != nil

#____________________________________________________
test nstd.Prefix&" Logger: Helpers":
  # Log Level Keynames
  check Log.Info.key  == "Info"
  check Log.Wrn.key   == "Warn"
  check Log.Err.key   == "Error"
  check Log.Fatal.key == "Fatal"
  check Log.Dbg.key   == "Debug"
  check Log.Trc.key   == "Trace"
  try: discard Log.None.key(); check false
  except LogError: check true
  try: discard Log.All.key(); check false
  except LogError: check true
  # Default File Path
  check helpers.getDefaultFile().lastPathPart() == currentSourcePath().lastPathPart().changeFileExt("log").Path
  # Log Format
  check helpers.Sep == "|"
  check PattDate    == "{getDateTime()}"
  check PattLevel   == "{level.key()}"
  check PattName    == "{logger.name}"
  check PattMsg     == "{msg}"
  check PattTrace   == "{getStackTrace()}"
  when off:  # Cannot check these, because they have a date. #todo: Would need to regex or pattern match them
    let con  = newConLogger(currentSourcePath().lastPathPart().changeFileExt("")&"_conLogger")
    echo con.formatMsg(Log.Info,  "test info message ",    42, 1234)
    echo con.formatMsg(Log.Wrn,   "test warning message ", 42, 5678)
    echo con.formatMsg(Log.Err,   "test error message ",   42, 9012)
    echo con.formatMsg(Log.Fatal, "test fatal message ",   42, 3456)
    echo con.formatMsg(Log.Dbg,   "test dbg message ",     42, 7890)
    echo con.formatMsg(Log.Trc,   "test trc message ",     42, 1234)
#____________________________________________________
test nstd.Prefix&" Logger: Helpers":
  # File Logger process
  let logg = newFileLogger(currentSourcePath().lastPathPart().changeFileExt("")&"_fileLogger")
  try: logg.log(Log.Info, "Test Writing to a file.")
  except LogError: check false
  check helpers.getDefaultFile().string.readFile != ""
  logg.clear()
  check helpers.getDefaultFile().string.readFile == ""
  try:
    for id in 0..<100: logg.log(Log.Info, "Test Writing to a file ", id)
  except LogError: check false
  try:
    for id in 0..<25:
      logg.log(Log.Info, "Test Writing to a file ", id)
      logg.trc("Test Writing trace to a file ", id)
      logg.dbg("Test Writing debug to a file ", id)
      logg.info("Test Writing info  to a file ", id)
      logg.wrn("Test Writing warn  to a file ", id)
      logg.err("Test Writing error to a file ", id)
      logg.fatal("Test Writing fatal to a file ", id)
  except LogError: check false
  check helpers.getDefaultFile().string.readFile != ""
  logg.clear()
  check helpers.getDefaultFile().string.readFile == ""
  helpers.getDefaultFile().string.removeFile()

