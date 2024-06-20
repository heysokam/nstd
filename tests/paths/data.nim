#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps All Tests
include ../base
# @deps std
from std/os import `/`
import std/importutils as imp
from std/paths as std import nil
# @deps n*std.paths
import nstd/paths/types {.all.} as paths
imp.privateAccess(paths.Path)


#_______________________________________
# @section Test Data
#_____________________________
# Test Data: Generic
const T * = (
  Dir      : std.Path"/path/to/dir",
  Sub      : std.Path"some/sub",
  Name     : std.Path"filename",
  Ext      : ".ext",
  Handle   : nil.File,
  Mode     : fmAppend,
  ) # << T = ( ... )
const Hello * = (
  Data   : "hello\n",
  Path   : Path.new(
    dir  = std.Path thisDir(),
    base = std.Path("hellofile"&".ext"),
    ), # << Path.new(... )
  ) # << Hello = ( ... )
const Dummy * = (
  Dir     : thisDir()/"dummy",
  Path    : Path(kind: paths.Kind.Dir,
    dir_p : std.Path(thisDir()),
    sub_p : std.Path"dummy"
    ), # << Path(kind: paths.Kind.Dir, ... )
  ) # << Dummy = ( ... )
#___________________
# Test Data: Path Dir
const testDir * = Path.new(
  dir = T.Dir,
  sub = T.Sub,
  ) # << Path.new( ... )
#___________________
# Test Data: Path File
const testFile * = Path.new(
  dir  = T.Dir,
  sub  = T.Sub,
  base = std.Path T.Name.string&T.Ext,
  ) # << Path(kind: paths.Kind.File, ... )
#___________________
# Test Data: PathHandle
const testHandle * = paths.PathHandle(
  file   : testFile,
  handle : T.Handle,
  mode   : T.Mode,
  ) # << PathHandle( ... )

