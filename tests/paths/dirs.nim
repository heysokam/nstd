#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps All Tests
include ../base
# @deps std
from std/os import nil
import std/importutils as imp
from std/paths as std import `==`, `/`
# @deps n*std.paths
import nstd/paths/types {.all.} as paths
# @deps Paths Tests
import ./data


#_______________________________________
# @section Paths: Directory Names
#_____________________________
suite "Paths: Directory Names":
  #_____________________________
  test "thisDir"    : check os.lastPathPart(    nstd.paths.thisDir() ) == "paths"
  test "thisFile"   : check os.lastPathPart(   nstd.paths.thisFile() ) == "dirs.nim"
  test "projectDir" : check os.lastPathPart( nstd.paths.projectDir() ) == ""


#_______________________________________
# @section Paths: Directory Tools
#_____________________________
suite "Paths: Directory Tools":
  #_____________________________
  test "Path.remove":
    os.createDir(Dummy.Dir)
    check os.dirExists(Dummy.Dir) == true
    Dummy.Path.remove()
    check os.dirExists(Dummy.Dir) == false
    check true

