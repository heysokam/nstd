#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps All Tests
include ../base
# @deps std
from std/os import `/`
import std/importutils as imp
# @deps n*std.paths
import nstd/paths/types {.all.} as paths
imp.privateAccess(paths.Path)
# @deps Paths Tests
import ./data


#_______________________________________
# @section Path: Access
#_____________________________
suite "Paths: Access":
  #_____________________________
  test "Path.dir":
    check testDir.dir  == T.Dir 
    check testFile.dir == T.Dir
    expect PathError: discard UndefinedPath.dir 
  #_____________________________
  test "Path.sub":
    check testDir.sub  == T.Sub
    check testFile.sub == T.Sub
    expect PathError: discard UndefinedPath.sub


#_______________________________________
# @section Path: Aliased tools
#_____________________________
suite "Paths: Aliased Tools":
  #_____________________________
  test "Path.path":
    check testDir.path  == string( T.Dir/T.Sub )
    check testFile.path == string( T.Dir/T.Sub/T.Name ) & T.Ext
    expect PathError: discard UndefinedPath.path
  #_____________________________
  test "Path.lastPathPart":
    check testDir.lastPathPart  == os.lastPathPart(T.Sub.string)
    check testFile.lastPathPart == T.Name.string & T.Ext
    try: discard UndefinedPath.lastPathPart except CatchableError: check true
  #_____________________________
  test "Path.basename":
    check testDir.basename  == os.lastPathPart(T.Sub.string)
    check testFile.basename == T.Name.string & T.Ext
    expect PathError: discard UndefinedPath.basename
    # Path.basename and Path.lastPathPart should be equivalent
    check testDir.basename  == testDir.lastPathPart
    check testFile.basename == testFile.lastPathPart
  #_____________________________
  test "Path.len":
    check testDir.len  == T.Dir.string.len + T.Sub.string.len + 1
    check testFile.len == T.Dir.string.len + T.Sub.string.len + T.Name.string.len + T.Ext.len + 2
    expect PathError: discard UndefinedPath.len
  #_____________________________
  test "Path.debug":
    check testDir.debug == """
Path :: /path/to/dir/some/sub
 dir  : /path/to/dir
 sub  : some/sub"""
    check testFile.debug == """
Path :: /path/to/dir/some/sub/filename.ext
 dir  : /path/to/dir
 sub  : some/sub
 name : filename
 ext  : .ext"""
    expect PathError: discard UndefinedPath.debug


#_______________________________________
# @section PathHandle: Access Extras
#_____________________________
suite "PathHandle: Access":
  #_____________________________
  test "PathHandle.path":
    check testHandle.path is paths.Path
    check testHandle.path.path == "/path/to/dir/some/sub/filename.ext"

