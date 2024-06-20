#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/os import nil
from std/paths as std import `/`, addFileExt
from std/hashes import Hash, hash
import std/importutils as imp
# @deps n*std.paths
import ../types {.all.} as paths
imp.privateAccess(paths.Path)
# @deps n*std
from ../../markers import unreachable
import ../../errors
import ../../strings

#____________________________________________________
# TODO:
# func `/` *(p :Path; s :string) :Path=  p/s.Path
# func `/` *(s :string; p :Path) :Path=  s.Path/p
# Modification time
# from std/times import `-`, inHours
# proc lastMod *(trg :string|Path) :times.Time=
#   ## @descr Returns the last modification time of the {@arg trg} file, or empty if it cannot be found.
#   try:    result = os.getLastModificationTime( trg.string )
#   except: result = times.Time()
#____________________________________________________


#_______________________________________
# @section Path: Private Access
#_____________________________
func dir *(P :Path) :std.Path {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to access the `dir` field of an invalid Path:  {P}"
  result = P.dir_p
#_____________________________
func `dir=` *(P :var Path; val :std.Path) :void {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to assign a value to the `dir` field of an invalid Path:  {P}"
  P.dir_p = val
#___________________
func sub *(P :Path) :std.Path {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to access the `sub` field of an invalid Path:  {P}"
  result = P.sub_p
#_____________________________
func `sub=` *(P :var Path; val :std.Path) :void {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to assign a value to the `sub` field of an invalid Path:  {P}"
  P.sub_p = val
#___________________
func name *(P :Path) :std.Path {.inline.}=
  if   P.kind == Kind.File : result = P.name_p
  elif P.kind == Kind.Dir  : PathError.trigger &"Dirs don't have a name. Use Path.path or Path.lastPathPart:  {P}"
  else                     : PathError.trigger &"Tried to access the `name` field of an invalid Path:  {P}"
#___________________
func `name=` *(P :var Path; val :std.Path) :void {.inline.}=
  if   P.kind == Kind.File : P.name_p = val
  elif P.kind == Kind.Dir  : PathError.trigger &"Cannot assign a name to a dir. Only files have filenames. Path was:  {P}"
  else                     : PathError.trigger &"Tried to assign a value to the `name` field of an invalid Path:  {P}"
#___________________
func ext *(P :Path) :string {.inline.}=
  if   P.kind == Kind.File : result = P.ext_p
  elif P.kind == Kind.Dir  : PathError.trigger &"Dirs don't have extension:  {P}"
  else                     : PathError.trigger &"Tried to access the `ext` field of an invalid Path:  {P}"
#___________________
func `ext=` *(P :var Path; val :string) :void {.inline.}=
  if   P.kind == Kind.File : P.ext_p = val
  elif P.kind == Kind.Dir  : PathError.trigger &"Cannot assign an ext to a dir. Only files have exts. Path was:  {P}"
  else                     : PathError.trigger &"Tried to assign a value to the `ext` field of an invalid Path:  {P}"


#_______________________________________
# @section Path: Aliased tools
#_____________________________
func path *(P :Path) :string {.inline.}=
  ## @descr Converts {@arg P} to its complete path representation.
  if P.kind notin SomePath: PathError.trigger &"Tried to access the path of an UndefinedPath:  {P}"
  case P.kind
  of Kind.File : result = string( P.dir/P.sub/P.name.addFileExt(P.ext) )
  of Kind.Dir  : result = string( P.dir/P.sub )
  else         : unreachable
#_____________________________
func lastPathPart *(P :Path) :string {.inline.}=
  case P.kind
  of SomePath : result = os.lastPathPart( P.path )
  else : PathError.trigger &"Tried to access the `lastPathPart` of an invalid Path:  {P}"
#_____________________________
func basename *(P :Path) :string {.inline.}= P.lastPathPart
proc len      *(P :Path) :int {.inline.}= P.path.len
proc hash     *(P :Path) :Hash {.inline.}= P.path.hash
#_____________________________
const BaseTempl = """
Path :: {P.path}
 dir  : {P.dir.string}
 sub  : {P.sub.string}"""
const DirTempl  = BaseTempl
const FileTempl = DirTempl & """

 name : {P.name.string}
 ext  : {P.ext}"""
#___________________
proc debug *(P :Path) :string=
  case P.kind
  of Kind.Dir  : result = fmt DirTempl
  of Kind.File : result = fmt FileTempl
  else         : PathError.trigger &"Tried to access the debug info of an invalid Path:  {P}"


#_______________________________________
# @section PathHandle: Access Extras
#_____________________________
func path *(P :PathHandle) :Path {.inline.}=  P.file
  ## @descr Alias for PathHandle.file

