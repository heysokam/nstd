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
# @section Conversion
#_____________________________
suite "Path: Convert":
  #_____________________________
  test "Path.toStr":
    check testDir.toStr  is string
    check testDir.toStr  == "/path/to/dir/some/sub"
    check testFile.toStr is string
    check testFile.toStr == "/path/to/dir/some/sub/filename.ext"
  #_____________________________
  test "$Path":
    check $testDir  is string
    check $testDir  == "/path/to/dir/some/sub"
    check $testFile is string
    check $testFile == "/path/to/dir/some/sub/filename.ext"
    check $testDir  == testDir.toStr
    check $testFile == testFile.toStr

