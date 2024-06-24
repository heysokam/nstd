#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path Files
#___________________________|
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
import ./core/validate
import ./core/access


#____________________________________________________
# TODO:
# proc appendFile *(trg :string|Path; data :string) :void=
#   ## @descr Opens the {@arg trg} file and adds the {@arg data} contents to it without erasing the existing contents.
#   let file = when trg is string: trg else: trg.string
#   let F = file.open( fmAppend )
#   F.write(data)
#   F.close()
# proc readLines *(trg :string|Path) :seq[string]=  trg.readFile.splitLines
#   ## @descr Reads the file and returns a seq[string] where is entry is a new line of the file
#____________________________________________________


#_______________________________________
# @section File Path tools
#_____________________________
proc read *(P :Fil) :string {.inline.}=
  case P.kind
  of Kind.File : result = system.readFile( toStr(P) )
  of Kind.Dir  : PathError.trigger &"Tried to read data from a folder Path:  {P}"
  else         : PathError.trigger &"Tried to read from an invalid Path:  {P}"
#___________________
proc read_static *(P :Fil) :string {.inline.}=
  case P.kind
  of Kind.File : result = system.staticRead( toStr(P) )
  of Kind.Dir  : PathError.trigger &"Tried to read data from a folder Path:  {P}"
  else         : PathError.trigger &"Tried to read from an invalid Path:  {P}"
#___________________
proc write *(P :Fil; data :string) :void {.inline.}=
  case P.kind
  of Kind.File : system.writeFile( toStr(P), data )
  of Kind.Dir  : PathError.trigger &"Tried to write data to a folder Path:  {P}"
  else         : PathError.trigger &"Tried to write to an invalid Path:  {P}"
#___________________
proc erase *(P :Fil) :void {.inline.}=
  case P.kind
  of Kind.File : system.writeFile( toStr(P), "" )
  of Kind.Dir  : PathError.trigger &"Erasing a folder is not implemented yet:  {P}"
  else         : PathError.trigger &"Tried to erase an invalid Path:  {P}"
#___________________
proc setExec *(trg :Fil) :void=
  ## @descr Sets the given {@arg trg} file flags to be executable for the current user.
  os.setFilePermissions(trg.path, {os.FilePermission.fpUserExec}, followSymlinks = false)


#_______________________________________
# @section File Path: Fields Management
#_____________________________
func changeExt *(P :Path; ext :string) :Path=
  if P.kind notin SomePath : PathError.trigger &"Tried to change the extension of an invalid Path:  {P}"
  if P.kind != Kind.File   : PathError.trigger &"Tried to change the extension of Folder Path:  {P}"
  result     = P
  result.ext = ext
#___________________
func stripExt *(P :Path) :Path=
  ## @descr Removes the file extension of {@arg P} only when it is a file and its extension is not a known Non-Extension suffix
  if not P.hasExt: return P
  result = P.changeExt("")


#_______________________________________
# @section PathHandle tools
#_____________________________
proc erase *(P :PathHandle) :void=
  ## @descr
  ##  Deletes the -contents- of the file pointed to by the {@arg P} PathHandle object.
  ##  Does nothing if the file handle has not being opened yet.
  ## @note
  ##  Re-Opening the file in write mode has the effect of immediately clearing the file.
  ##  The file is kept open in append mode for normal use.
  if not isOpen(P): return
  discard P.handle.reopen(P.file.toStr, fmWrite)
  discard P.handle.reopen(P.file.toStr, P.mode)

