#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps All Tests
include ../base
# @deps std
import std/importutils as imp
from std/paths as std import `==`, `/`
# @deps n*std.paths
import nstd/paths/types {.all.} as paths
imp.privateAccess(paths.Path)
# @deps Paths Tests
import ./data



#_______________________________________
# @section Path Constructors
#_____________________________
suite "Paths: Constructors":
  #___________________
  test "paths.create.path":
    let D1 = Path.new(T.Dir.string, sub= T.Sub.string)
    check D1 is paths.Path
    check D1.kind  == paths.Kind.Dir
    check D1.toStr == "/path/to/dir/some/sub"
    let F1 = Path.new(T.Dir.string, "filename.ext", sub= T.Sub.string)
    check F1 is paths.Path
    check F1.kind  == paths.Kind.File
    check F1.toStr == "/path/to/dir/some/sub/filename.ext"
    let D2 = Path.new(T.Dir.string)
    check D2 is paths.Path
    check D2.kind  == paths.Kind.Dir
    check D2.toStr == "/path/to/dir"
    let F2 = Path.new(T.Dir.string, "filename.ext")
    check F2 is paths.Path
    check F2.kind  == paths.Kind.File
    check F2.toStr == "/path/to/dir/filename.ext"
  #___________________
  test "Path.new":
    let D1 = Path.new(T.Dir.string, sub= T.Sub.string)
    check D1 is paths.Path
    check D1.kind  == paths.Kind.Dir
    check D1.toStr == "/path/to/dir/some/sub"
    let F1 = Path.new(T.Dir.string, "filename.ext", sub= T.Sub.string)
    check F1 is paths.Path
    check F1.kind  == paths.Kind.File
    check F1.toStr == "/path/to/dir/some/sub/filename.ext"
    let D2 = Path.new(T.Dir.string)
    check D2 is paths.Path
    check D2.kind  == paths.Kind.Dir
    check D2.toStr == "/path/to/dir"
    let F2 = Path.new(T.Dir.string, "filename.ext")
    check F2 is paths.Path
    check F2.kind  == paths.Kind.File
    check F2.toStr == "/path/to/dir/filename.ext"


#_______________________________________
# @section Path Constructors
#_____________________________
suite "Paths: Constructors":
  #___________________
  test "PathHandle.new string":
    let P1 = PathHandle.new( testFile, nil, fmAppend)
    check testHandle.file   == P1.file
    check testHandle.handle == P1.handle
    check testHandle.mode   == P1.mode
  test "PathHandle.new Path":
    let P2 = PathHandle.new(string( T.Dir/T.Sub/std.Path(T.Name.string&T.Ext) ), nil, fmAppend)
    check testHandle.file   == P2.file
    check testHandle.handle == P2.handle
    check testHandle.mode   == P2.mode

