#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps All Tests
include ../base
# @deps std
import std/importutils as imp
from std/paths as std import `==`
# @deps n*std.paths
import nstd/paths/types {.all.} as paths
imp.privateAccess(paths.Path)
# @deps Paths Tests
import ./data


#_______________________________________
# @section Path Tests
#_____________________________
suite "Paths: Types":
  #_____________________________
  test "Kinds: All":
    for entry in paths.Kind:
      case entry.ord
      of 0 : check $entry == "Undefined"
      of 1 : check $entry == "Dir"
      of 2 : check $entry == "File"
      else : assert false, "Found and unmapped Path kind"
  #_____________________________
  test "Kinds: SomePath":
    check paths.Kind.Dir in SomePath
    check paths.Kind.File in SomePath
  #_____________________________
  test "Object Fields: Undefined":
    # Check UndefinedPath
    check UndefinedPath.kind is paths.Kind
    # Should fail to access any other fields
    expect PathError: discard UndefinedPath.dir
    expect PathError: discard UndefinedPath.sub
    expect PathError: discard UndefinedPath.name
    expect PathError: discard UndefinedPath.ext
  #_____________________________
  test "Object Fields: Dir":
    # Check Dir fields
    check testDir.kind is paths.Kind
    check testDir.dir  is string
    check testDir.sub  is string
    # Should not be able to access File fields
    expect PathError: discard testDir.name
    expect PathError: discard testDir.ext
  #_____________________________
  test "Object Fields: File":
    # Check File fields
    check testFile.kind is paths.Kind
    check testFile.dir  is string
    check testFile.sub  is string
    check testFile.name is string
    check testFile.ext  is string
  #_____________________________
  test "Data: Undefined":
    check UndefinedPath.kind == paths.Kind.Undefined
  #_____________________________
  test "Data: Dir":
    check testDir.kind == paths.Kind.Dir
    check testDir.dir  == T.Dir
    check testDir.sub  == T.Sub
  #_____________________________
  test "Data: File":
    check testFile.kind == paths.Kind.File
    check testFile.dir  == T.Dir
    check testFile.sub  == T.Sub
    check testFile.name == T.Name
    check testFile.ext  == T.Ext


#_______________________________________
# @section PathHandle Tests
#_____________________________
suite "PathHandle: Types":
  #_____________________________
  test "Object Fields":
    check testHandle.file   is paths.Path
    check testHandle.handle is system.File
    check testHandle.mode   is system.FileMode
  #_____________________________
  test "Data":
    check testHandle.file.kind == paths.Kind.File
    check testHandle.handle    == T.Handle
    check testHandle.mode      == T.Mode

