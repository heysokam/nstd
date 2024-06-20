#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Tools common to both Files and Dirs
#____________________________________________________|
# @deps std
from std/os import nil
import std/importutils as imp
# @deps n*std
import ../errors
import ../strings
# @deps n*std.paths
import ./types {.all.} as paths
imp.privateAccess(paths.Path)
import ./core/convert
import ./core/create
import ./core/access


#_______________________________________
# TODO:
# proc copyDirWithPermissions *(a,b :Path; ignorePermissionErrors = true) :void {.borrow.}
# proc replace *(trg :Path; A,B :string|Path) :Path= trg.string.replace(A.string, B.string).Path
#_______________________________________


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

