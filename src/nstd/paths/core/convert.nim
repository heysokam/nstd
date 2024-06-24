#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path Conversion Tools
#______________________________________|
# @deps std
from std/importutils as imp import nil
# @deps n*std
import ../../errors
import ../../strings
# @deps n*std.paths
import ../types {.all.} as paths
imp.privateAccess(paths.Path)
import ./access


#_______________________________________
# @section Conversion
#_____________________________
func toStr *(P :Path) :string=
  if P.kind notin SomePath: PathError.trigger &"Tried to convert an invalid Path into a string:  {P}"
  result = P.path
#_____________________________
func `$` *(P :Path) :string= convert.toStr(P)
#_____________________________
# when not defined(noConversion_PathToString):  # Opt-in to remove this converter on cli
#  converter toString *(P :Path) :string= P.path
converter toString *(P :Path) :string= P.path

