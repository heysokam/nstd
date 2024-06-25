#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Tools common to both Files and Dirs
#____________________________________________________|
# @deps std
from std/os import nil
import std/importutils as imp
# @deps n*std
import ../strings
import ../errors
from ../markers import unreachable
# @deps n*std.paths
import ./types {.all.} as paths
imp.privateAccess(paths.Path)
import ./core/convert
import ./core/create
import ./core/access


#_______________________________________
# @section Paths: Files+Folders functionality
#_____________________________
proc remove *(P :Path) :void {.inline.}=
  case P.kind
  of Kind.File : os.removeFile( toStr(P) )
  of Kind.Dir  : os.removeDir(  toStr(P) )
  else         : PathError.trigger &"Tried to remove an invalid Path:  {P}"
#___________________
proc chgDir *(
    P    : Path;
    to   : string;
    sub  : string= "";
  ) :Path {.inline.}=
  ## @descr
  ##  Returns a new Path, based on {@arg P}, with its directory changed to {@arg to}.
  ##  Will change the {@link Path.sub} field of {@arg P} when {@arg sub} is provided.
  case P.kind
  of Kind.File : result = create.path(P.dir,
    base = P.name.string&P.ext,
    sub  = if sub != "": sub else: P.sub.string
    ) # << create.path(P.dir, ... )
  of Kind.Dir  : result = create.path(P.dir,
    sub= if sub != "": sub else: P.sub.string
    ) # << create.path(P.dir, ... )
  else : PathError.trigger &"Tried to change the `dir` of an invalid Path:  {P}"
#___________________
proc chgDir *(
    P    : Path;
    to   : Dir;
    sub  : string= "";
  ) :Path {.inline.}=
  ## @descr
  ##  Returns a new Path, based on {@arg P}, with its directory changed to {@arg to}.
  ##  Will change {@arg P.sub} to {@arg sub} if it is provided. Otherwise it will use {@arg to.sub}
  if sub != "" : result = P.chgDir(to.dir, sub)
  else         : result = P.chgDir(to.dir, to.sub)
#___________________
proc replace *(P :Path; A,B :string) :Path=
  if P.kind notin SomePath : PathError.trigger &"Tried to replace the contents of an invalid Path:  {P}"
  result  = P.chgDir(
    to  = P.dir.replace(A, B),
    sub = P.sub.replace(A, B)
    ) # << P.chgDir( .. )
  case P.kind
  of Kind.File :
    result.name = result.name.replace(A,B)
    result.ext  = result.ext.replace(A,B)
  else: unreachable
#___________________
proc add *(P :Path; A :string) :Path=
  ## @descr Adds a string at the end of {@arg P} Path, without applying any `/` separators
  if P.kind notin SomePath : PathError.trigger &"Tried to add a new subpath to an invalid Path:  {P}"
  result = P
  case P.kind
  of Kind.File :
    if   P.ext  != "" : result.ext  = result.ext  & A
    elif P.name != "" : result.name = result.name & A
    else              : PathError.trigger &"Tried to add a new subpath to a file that doesn't have basename values:  {P}"
  of Kind.Dir  :
    if   P.sub != "" : result.sub = result.sub & A
    elif P.dir != "" : result.dir = result.dir & A
    else             : PathError.trigger &"Tried to add a new subpath to a folder that doesn't have dirSub values:  {P}"
  else: unreachable



#_______________________________________
# @section Paths: Files+Folders functionality
#_____________________________
proc copyWithPermissions *(
    src                    : Path;
    trg                    : Path;
    ignorePermissionErrors : bool = true;
  ) :void {.inline.}=
  case src.kind
  of Kind.File : os.copyFileWithPermissions(src.path, trg.path, ignorePermissionErrors)
  of Kind.Dir  : os.copyDirWithPermissions(src.path, trg.path, ignorePermissionErrors)
  else         : unreachable

