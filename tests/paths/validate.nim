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


#______________________________________
# @section Validate: Existence
#_____________________________
suite "Paths: Validate Existence":
  #_____________________________
  test "Path.exists":
    let valid = Path.new(thisDir(), "validate.nim")
    check testFile.exists == os.fileExists(testFile.path)
    check testDir.exists  == os.dirExists(testFile.path)
    check valid.exists    == true
    try: discard UndefinedPath.exists except CatchableError: check true


#______________________________________
# @section Validate: Fields
#_____________________________
suite "Paths: Validate Fields":
  #_____________________________
  test "Path.isKind":
    check testFile.isKind( paths.Kind.File ) == true
    check testFile.isKind( paths.Kind.Dir  ) == false
    check testDir.isKind(  paths.Kind.File ) == false
    check testDir.isKind(  paths.Kind.Dir  ) == true
    check UndefinedPath.isKind(paths.Kind.Undefined) == true
  #_____________________________
  test "Path.isFile":
    check testFile.isFile == true
    check testDir.isFile  == false
    check UndefinedPath.isFile == false
  #_____________________________
  test "Path.isDir":
    check testFile.isDir == false
    check testDir.isDir  == true
    check UndefinedPath.isDir == false
  #_____________________________
  test "Path.hasSub":
    check testFile.hasSub == true
    check testDir.hasSub  == true
    check UndefinedPath.hasSub == false
  #_____________________________
  test "Path.hasExt":
    check testFile.hasExt == true
    check testDir.hasExt  == false
    check UndefinedPath.hasExt == false


#______________________________________
# @section PathHandle Validate: Fields
#_____________________________
suite "PathHandle: Validate Fields":
  #_____________________________
  test "PathHandle.isOpen":
    check testHandle.isOpen == false
  #_____________________________
  test "PathHandle.isReadonly":
    check testHandle.isReadonly == false
  #_____________________________
  test "PathHandle.isWriteonly":
    check testHandle.isWriteonly == false
  #_____________________________
  test "PathHandle.isReadWrite":
    check testHandle.isReadWrite == false
  #_____________________________
  test "PathHandle.isAppend":
    check testHandle.isAppend == true

