#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
include ./base
# Specific for this test
import std/os
import nstd/logger/helpers



#____________________________________________________
suite nstd.Prefix&" Logger: Types":
  test "Valid":
    check nstd.LogFunc is proc (args: varargs[string, `$`]) :void
    check nstd.LvlFunc is proc (lvl :Log; args: varargs[string, `$`]) :void
    check nstd.Log.high.ord == 8-1  # Panic if we added a level but didn't make a test for it

#____________________________________________________
suite nstd.Prefix&" Logger: Constructors":
  let verb = when nstd.debug: true else: false
  test "Logger with Defaults":
    let con = newConLogger(currentSourcePath().lastPathPart().changeFileExt("")&"_conLogger")
    check con.name        == "tLogger_conLogger"
    check con.kind        == logger.Kind.ConLogger
    check con.threshold   == Log.All  # might fail if cfg.flushAll is changed for tests
    check con.flushLvl    == Log.Fatal
    check con.verbose     == verb
    check con.file.path   == UndefinedPath
    check con.file.mode   == fmAppend
    check con.file.handle == stdout
  test "Logger with Defaults":
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
suite nstd.Prefix&" Logger: Helpers":
  test "Log Level Keynames":
    check Log.Info.key  == "Info"
    check Log.Wrn.key   == "Warn"
    check Log.Err.key   == "Error"
    check Log.Fatal.key == "Fatal"
    check Log.Dbg.key   == "Debug"
    check Log.Trc.key   == "Trace"
    expect LogError: discard Log.None.key()
    expect LogError: discard Log.All.key()
  test "Default File Path":
    check helpers.getDefaultFile().lastPathPart() == currentSourcePath().lastPathPart().changeFileExt("log")
  test "Log Format":
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
suite nstd.Prefix&" Logger: Helpers":
  test "File Logger process":
    let logg = newFileLogger(currentSourcePath().lastPathPart().changeFileExt("")&"_fileLogger")
    try                   : logg.log(Log.Info, "Test Writing to a file.")
    except CatchableError : check false
    check helpers.getDefaultFile().read != ""
    logg.clear()
    check helpers.getDefaultFile().read == ""
    try:
      for id in 0..<100: logg.log(Log.Info, "Test Writing to a file ", id)
    except CatchableError : check false
    try:
      for id in 0..<25:
        logg.log(Log.Info, "Test Writing to a file ", id)
        logg.trc("Test Writing trace to a file ", id)
        logg.dbg("Test Writing debug to a file ", id)
        logg.info("Test Writing info  to a file ", id)
        logg.wrn("Test Writing warn  to a file ", id)
        logg.err("Test Writing error to a file ", id)
        logg.fatal("Test Writing fatal to a file ", id)
    except CatchableError : check false
    check helpers.getDefaultFile().read != ""
    logg.clear()
    check helpers.getDefaultFile().read == ""
    helpers.getDefaultFile().remove()

