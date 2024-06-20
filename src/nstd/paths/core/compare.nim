#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
import std/importutils as imp
# @deps n*std.paths
import ../types {.all.} as paths
imp.privateAccess(paths.Path)
import ./convert


#_______________________________________
# @section Path Comparison
#_____________________________
func `==` *(A,B :Path) :bool=
  if   A.kind == Kind.Undefined and B.kind == Kind.Undefined: return true
  elif A.kind == Kind.Undefined or  B.kind == Kind.Undefined: return false
  toStr(A) == toStr(B)
#_____________________________
proc `<` *(A,B :Path) :bool=
  if A.kind == Kind.Undefined or B.kind == Kind.Undefined: return false
  toStr(A) < toStr(B)

