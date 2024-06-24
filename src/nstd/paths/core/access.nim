#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/os import `/`
from std/paths as std import `/`, addFileExt
from std/hashes import Hash, hash
import std/importutils as imp
from std/times import `-`, inHours
# @deps n*std
from ../../markers import unreachable
import ../../errors
import ../../strings
# @deps n*std.paths
import ../types {.all.} as paths
imp.privateAccess(paths.Path)
import ./base


#_______________________________________
# @section Path: Private Access
#_____________________________
func dir *(P :Path) :string {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to access the `dir` field of an invalid Path:  {P}"
  result = P.dir_p.string
#_____________________________
func `dir=` *(P :var Path; val :string|std.Path) :void {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to assign a value to the `dir` field of an invalid Path:  {P}"
  P.dir_p = val.toStdPath
#___________________
func sub *(P :Path) :string {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to access the `sub` field of an invalid Path:  {P}"
  result = P.sub_p.string
#_____________________________
func `sub=` *(P :var Path; val :string|std.Path) :void {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to assign a value to the `sub` field of an invalid Path:  {P}"
  P.sub_p = val.toStdPath
#___________________
func name *(P :Path) :string {.inline.}=
  if   P.kind == Kind.File : result = P.name_p.string
  elif P.kind == Kind.Dir  : PathError.trigger &"Dirs don't have a name. Use Path.path or Path.lastPathPart:  {P}"
  else                     : PathError.trigger &"Tried to access the `name` field of an invalid Path:  {P}"
#___________________
func `name=` *(P :var Path; val :string|std.Path) :void {.inline.}=
  if   P.kind == Kind.File : P.name_p = val.toStdPath
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
# @section Path: Combined Names
#_____________________________
func dirSub *(P :Path) :string {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to access the dir+sub values of an UndefinedPath:  {P}"
  result = P.dir/P.sub
#_____________________________
func basename *(P :Path) :string {.inline.}=
  if P.kind notin SomePath: PathError.trigger &"Tried to access the basename of an UndefinedPath:  {P}"
  case P.kind
  of Kind.File : result = os.addFileExt(P.name, P.ext)
  of Kind.Dir  : result = os.lastPathPart(P.dirSub)
  else         : unreachable
#_____________________________
func path *(P :Path) :string {.inline.}=
  ## @descr Converts {@arg P} to its complete path representation.
  if P.kind notin SomePath: PathError.trigger &"Tried to access the path of an UndefinedPath:  {P}"
  case P.kind
  of Kind.File : result = P.dirSub/P.basename
  of Kind.Dir  : result = P.dirSub
  else         : unreachable
#_____________________________
func lastPathPart *(P :Path) :string {.inline.}=
  case P.kind
  of SomePath : result = os.lastPathPart( P.path )
  else : PathError.trigger &"Tried to access the `lastPathPart` of an invalid Path:  {P}"


#_______________________________________
# @section Path: Aliased tools
#_____________________________
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
# @section Path Resolution
#_____________________________
func `/` (P :std.Path; S :string) :std.Path=  P/std.Path(S)
func `/` (S :string; P :std.Path) :std.Path=  std.Path(S)/P
#___________________
proc `/` *(P :Path; S :string) :Path=
  # @note Ugly as hell. This function has so many edge cases to make it smart enough to recognize a Dir-to-File or File-to-Dir change
  let F          = os.splitFile(S)
  let isDotDir   = S == "." or S == ".."
  let mightBeDir = (not isDotDir and S.startsWith(".") and F.ext != "")
  let kind       =
    if   isDotDir                               : Kind.Dir
    elif mightBeDir and os.dirExists(P.path/S)  : Kind.Dir
    elif mightBeDir and os.fileExists(P.path/S) : Kind.File
    elif F.ext != ""                            : Kind.File
    else                                        : P.kind  # TODO: Probably wont work, because *Exists won't trigger for new paths
  case kind
  of Kind.Dir  : result = P # Keep dirs as dirs
  of Kind.File : result = paths.newFile(P.dir, F.name, F.ext, sub=P.sub)
  else         : unreachable

  case P.kind
  of Kind.Dir             :
    if   P.sub != ""      : result.sub = result.sub/S
    elif kind == Kind.Dir : result.dir = result.dir/S
    else                  : discard
  of Kind.File            :
    if P.ext == ""        : result.name = result.name/S
    else                  : PathError.trigger &"Tried to join a string into a File Path, but the file has an extension:  {P} : {S}"
  else                    : PathError.trigger &"Tried to join a string into an invalid Path:  {P} : {S}"
#___________________
proc `/` *(S :string; P :Path) :Path=
  result = P
  case P.kind
  of paths.SomePath : result.dir = S/P.dir
  else              : PathError.trigger &"Tried to join a string into an invalid Path:  {P} : {S}"
#___________________
proc `/` *(A,B :Path) :Path=
  if A.kind notin SomePath : PathError.trigger &"Tried to join a two paths, but the first one was invalid:  {A} : {B}"
  if B.kind notin SomePath : PathError.trigger &"Tried to join a two paths, but the second one was invalid:  {A} : {B}"
  case A.kind
  of Kind.Dir    :
    case B.kind
    of Kind.Dir  : result = A.path/B # Dir/Dir
    of Kind.File : result = A.path/B # Dir/File
    else         : unreachable
  of Kind.File   :
    case B.kind
    of Kind.Dir  : PathError.trigger &"Tried to join the paths of a file and a folder together, but the file was send as the first argument:  {A.path} : {B.path}" # File/Dir
    of Kind.File : PathError.trigger &"Tried to join the paths of two files together:  {A.path} : {B.path}" # File/File
    else         : unreachable
  else           : unreachable
#___________________
proc absolute *(
    P    : Path;
    root : Dir = paths.newdir(os.getCurrentDir())
  ) :Path=
  if P.kind   notin paths.SomePath: PathError.trigger &"Tried to get the absolute path of a Path, but the first argument is an invalid Path:  {P} : {root}"
  if root.kind notin paths.SomePath: PathError.trigger &"Tried to get the absoluterelative path of a Path, but the second argument is an invalid Path:  {P} : {root}"
  let dir = os.absolutePath(P.dirSub, root.dirSub)
  case P.kind
  of Kind.File : result = paths.newFile(dir, P.basename)
  of Kind.Dir  : result = paths.newDir(dir)
  else         : unreachable
#___________________
proc relative *(P,rel :Path) :Path=
  ## @warning The {@link Path.sub} information of {@arg P} is lost during this processs
  if P.kind   notin paths.SomePath: PathError.trigger &"Tried to get the relative path of a Path, but the first argument is an invalid Path:  {P} : {rel}"
  if rel.kind notin paths.SomePath: PathError.trigger &"Tried to get the relative path of a Path, but the second argument is an invalid Path:  {P} : {rel}"
  let dir = os.relativePath(P.dirSub, rel.dirSub)
  case P.kind
  of Kind.File : result = paths.newFile(dir, P.basename)
  of Kind.Dir  : result = paths.newDir(dir)
  else         : unreachable
#___________________
proc parent *(P :Path) :Dir=
  if P.kind notin paths.SomePath: PathError.trigger &"Tried to get the parent of an invalid Path:  {P}"
  case P.kind
  of Kind.File : result = paths.newDir(P.dir, P.sub)
  of Kind.Dir  :
    let dir = P.dir.split(os.DirSep)
    let sub = P.sub.split(os.DirSep)
    if sub.len > 0:
      if sub.len == 1 : paths.newDir( P.dir )
      else            : paths.newDir( P.dir, sub= os.parentDir(P.sub) )
    elif dir.len > 0  : paths.newDir( os.parentDir(P.dir) )
    else              : unreachable
  else                : unreachable


#_______________________________________
# @section Modification time
#_____________________________
proc lastMod *(trg :Path) :times.Time=
  ## @descr Returns the last modification time of the {@arg trg} path, or empty if it cannot be found.
  try:    result = os.getLastModificationTime( trg.path )
  except: result = times.Time()


#_______________________________________
# @section PathHandle: Access Extras
#_____________________________
func path *(P :PathHandle) :Path {.inline.}=  P.file
  ## @descr Alias for PathHandle.file

