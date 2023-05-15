#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# std dependencies
import std/os
import std/parseopt

#____________________________________
# Command line option parsing
proc getOpt *(c :string) :bool=
  result = false # default output is false, unless the opt is found
  var args = initOptParser(commandLineParams())
  for kind, key, val in args.getOpt():
    if kind in [cmdShortOption]:
      if key in [c]: result = true
#____________________________________
proc getBuildType *() :string=
  var args = initOptParser(commandLineParams())
  for kind, key, val in args.getOpt():
    if kind in [cmdLongOption, cmdShortOption]:
      if key in ["build", "b"]: result = val
#____________________________________
proc isVerbose *() :bool=
  result = false # default output is false, unless the opt is found
  var args = initOptParser(commandLineParams())
  for kind, key, val in args.getOpt():
    if kind in [cmdLongOption, cmdShortOption]:
      if key in ["verbose", "v"]: result = true
#____________________________________
func isLinux *() :bool=
  result=false; when defined(posix):   result = true
#____________________________________
func   isWin*() :bool= 
  result=false; when defined(windows): result = true

