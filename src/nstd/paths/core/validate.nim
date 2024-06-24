#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path Validation Tools
#______________________________________|
# @deps std
from std/os import nil
import std/importutils as imp
from std/sequtils import anyIt
from std/times import getTime, inHours, `-`
# @deps n*std
import ../../strings
import ../../errors
# @deps n*std.paths
import ../types {.all.} as paths
imp.privateAccess(Path)
import ./access


#____________________________________________________
# TODO:
# proc contains *(trg :Path; data :string) :bool= trg.string.contains(data)
# proc contains *(trg,data :Path) :bool= trg.string.contains(data.string)
# proc endsWith *(p :Path; A :char|string|Path) :bool= p.string.endsWith(A)
#____________________________________________________


#_______________________________________
# @section Path Validate: Access Time
#_____________________________
proc noModSince *(trg :string|Path; hours :SomeInteger) :bool=  ( times.getTime() - trg.lastMod ).inHours > hours
  ## @descr Returns true if the {@arg trg} file hasn't been modified in the last N {@arg hours}.


#______________________________________
# @section Path Validate: Existence
#_____________________________
proc exists *(P :Path) :bool {.inline.}=
  let path = path(P)
  case P.kind
  of Kind.File : result = os.fileExists(path)
  of Kind.Dir  : result = os.dirExists(path)
  else         : PathError.trigger &"Tried to validate if a Path exists, but it is not valid:  {path}"


#______________________________________
# @section Path Validate: Fields
#_____________________________
func isKind *(P :Path; K :Kind) :bool {.inline.}=  P.kind == K
#___________________
# proc isFile *(input :string|Path) :bool=  (input.len < 32_000) and (Path(input) != UndefinedPath) and (input.fileExists())
proc isFile *(P :Path) :bool {.inline.}=  P.isKind(Kind.File) or (P.path.len < 32_000 and os.fileExists(P.path))
  ## @descr Returns true if the input is a file.
  ##  Returns false:
  ##  : If path == Dir | UndefinedPath
  ##  : If the file exists but the length of the path is too long  (> 32_000)
#___________________
func isDir  *(P :Path) :bool {.inline.}=  P.isKind Kind.Dir
#___________________
func hasSub *(P :Path) :bool {.inline.}=
  case P.kind
  of SomePath : P.sub.string != ""
  else        : false
#___________________
const NonExtSuffixes = [".x64"]
func hasExt *(P :Path) :bool=
  case P.kind
  of Kind.File     :
    if P.ext == "" : return false
    else           : return not NonExtSuffixes.anyIt( P.path.endsWith(it) )  # none of the NonExtSuffixes match the end of P.path
  else             : return false


#______________________________________
# @section PathHandle Validate: Fields
#_____________________________
proc isOpen      *(P :PathHandle) :bool=  not P.handle.isNil
proc isReadonly  *(P :PathHandle) :bool=  P.mode == fmRead
proc isWriteonly *(P :PathHandle) :bool=  P.mode == fmWrite
proc isReadWrite *(P :PathHandle) :bool=  P.mode == fmReadWrite
proc isAppend    *(P :PathHandle) :bool=  P.mode == fmAppend

