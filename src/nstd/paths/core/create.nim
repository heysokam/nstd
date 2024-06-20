#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/os import nil
from std/paths as std import nil
import std/importutils as imp
# @deps n*std
import ../../strings
import ../../errors
# @deps n*std.paths
import ../types {.all.} as paths
imp.privateAccess(paths.Path)
import ./validate


#_______________________________________
# @section Path Constructors
#_____________________________
func path *(
    dir  : string|std.Path;
    sub  : string|std.Path = std.Path"";
  ) :Path=
  result = newDir(dir=dir, sub=sub)
#___________________
func path *(
    dir  : string|std.Path;
    base : string|std.Path;
    sub  : string|std.Path = std.Path"";
  ) :Path=
  result = newFile(dir= dir, base= when base is std.Path: base.string else: base, sub=sub)
#___________________
func new *(_:typedesc[Path];
    dir  : string|std.Path;
    base : string|std.Path = std.Path"";
    sub  : string|std.Path = std.Path"";
  ) :Path=
  let base = when base is std.Path: base.string else: base
  if base == "" : result = path(dir=dir, sub=sub)
  else          : result = path(dir=dir, base=base, sub=sub)


#_______________________________________
# @section PathHandle Constructors
#_____________________________
proc new *(_:typedesc[PathHandle];
    file   : Path;
    handle : File     = nil;
    mode   : FileMode = fmAppend;
  ) :PathHandle=
  if file.kind != Kind.File : PathError.trigger &"Tried to create a PathHandle from a Path that is not a File:  {file}"
  PathHandle(
  file   : file,
  handle : if file.exists() and handle.isNil: file.toStr.open(mode) else: handle,
  mode   : mode
  ) # << PathHandle( ... )
#___________________
proc new *(_:typedesc[PathHandle];
    file   : string;
    handle : File     = nil;
    mode   : FileMode = fmAppend;
  ) :PathHandle=
  ## @descr
  ##  Creates a new PathFile object from {@arg file}.
  ##  If a {@arg handle} is not passed, and {@arg file} exists, its handle will be open with {@arg mode}, and needs to be closed after use.
  let (dir, name, ext) = os.splitFile(file)
  result = PathHandle(
  file   : path(
    dir  = dir,
    base = name&ext,
    ), # << file : path( ... )
  ) # << PathHandle( ... )
  result.handle = if result.file.exists() and handle.isNil: result.file.toStr.open(mode) else: handle
  result.mode   = mode

