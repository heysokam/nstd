#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/unittest
# n*std dependencies
import nstd
# tests dependencies
import ./cfg


#____________________________________________________
test cfg.Prefix&"Logger: Types":
  check nstd.LogFunc is proc (args: varargs[string, `$`]) :void
  check nstd.LvlFunc is proc (lvl :Log; args: varargs[string, `$`]) :void
  check nstd.Log.high.ord == 8-1  # Panic if we added a level but didn't make a test for it








##[ OUTDATED ]#____________________________________________________
test cfg.Prefix&"Logger: Custom Mapping to std/logging":
  # Levels: Auto Converter
  check nstd.Log.All.ord   == std.Level.lvlAll.ord
  check nstd.Log.Trc.ord   == std.Level.lvlDebug.ord
  check nstd.Log.Dbg.ord   == std.Level.lvlInfo.ord
  check nstd.Log.Inf.ord   == std.Level.lvlNotice.ord
  check nstd.Log.Wrn.ord   == std.Level.lvlWarn.ord
  check nstd.Log.Err.ord   == std.Level.lvlError.ord
  check nstd.Log.Fatal.ord == std.Level.lvlFatal.ord
  check nstd.Log.None.ord  == std.Level.lvlNone.ord
  # Levels: Explicit Converter call
  check nstd.Log.All.toStd.ord   == std.Level.lvlAll.ord
  check nstd.Log.Trc.toStd.ord   == std.Level.lvlDebug.ord
  check nstd.Log.Dbg.toStd.ord   == std.Level.lvlInfo.ord
  check nstd.Log.Inf.toStd.ord   == std.Level.lvlNotice.ord
  check nstd.Log.Wrn.toStd.ord   == std.Level.lvlWarn.ord
  check nstd.Log.Err.toStd.ord   == std.Level.lvlError.ord
  check nstd.Log.Fatal.toStd.ord == std.Level.lvlFatal.ord
  check nstd.Log.None.toStd.ord  == std.Level.lvlNone.ord
  # Aliasing: Types
  check nstd.BaseLogger is std.Logger
  check nstd.ConLogger  is std.ConsoleLogger
  check nstd.FileLogger is std.FileLogger
  check nstd.RollLogger is std.RollingFileLogger
  # Aliasing: Procs
  # nstd.newConLogger  == std.newConsoleLogger
  # nstd.newFileLogger == std.newFileLogger
  # nstd.newRollLogger == std.newRollingFileLogger
  # nstd.addHandler    == std.addHandler
  # nstd.getHandlers   == std.getHandlers
  # nstd.getFilter     == std.getLogFilter
  # nstd.setFilter     == std.setLogFilter
  # nstd.defFilename   == std.defaultFilename
  # nstd.log           == std.log
  # nstd.fatal         == std.fatal

#____________________________________________________
test cfg.Prefix&"Logger: Creation": discard


var con = nstd.newConLogger(
  levelThreshold = lvlAll,
  fmtStr         = defaultFmtStr,
  useStderr      = false,
  flushThreshold = lvlAll,
  ) # << nstd.newConLogger( ... )
# echo nstd.defFilename()
trc "test"
con.log(Log.All, "test")
]##
