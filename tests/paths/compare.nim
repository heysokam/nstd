#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps All Tests
include ../base
# @deps std
import std/importutils as imp
# @deps n*std.paths
import nstd/paths/types {.all.} as paths
# @deps Paths Tests
import ./data


#_______________________________________
# @section Path Comparison
#_____________________________
suite "Paths: Compare":
  #___________________
  test "Path == Path":
    check testDir == Path.new(T.Dir, sub= T.Sub)
  #___________________
  test "Path < Path":
    check testDir < testFile
    check testFile > testDir

