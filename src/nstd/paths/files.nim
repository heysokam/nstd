#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path Files
#___________________________|
# @deps std
import std/importutils as imp
# @deps n*std
import ../errors
import ../strings
# @deps n*std.paths
import ./types {.all.} as paths
imp.privateAccess(paths.Path)
import ./core/convert
import ./core/validate


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
# const NonExtSuffixes = [".x64"]
# func stripFileExt *(path :Path) :Path=
#   ## @descr Removes the file extension of {@arg path} only when its not a known Non-Extension suffix
#   if NonExtSuffixes.anyIt( path.endsWith(it) ): return path
#   result = path.changeFileExt("")
#____________________________________________________


#_______________________________________
# @section File Path tools
#_____________________________
proc read *(P :Path) :string {.inline.}=
  case P.kind
  of Kind.File : result = system.readFile( toStr(P) )
  of Kind.Dir  : PathError.trigger &"Tried to read data from a folder Path:  {P}"
  else         : PathError.trigger &"Tried to read from an invalid Path:  {P}"
#___________________
proc read_static *(P :Path) :string {.inline.}=
  case P.kind
  of Kind.File : result = system.staticRead( toStr(P) )
  of Kind.Dir  : PathError.trigger &"Tried to read data from a folder Path:  {P}"
  else         : PathError.trigger &"Tried to read from an invalid Path:  {P}"
#___________________
proc write *(P :Path; data :string) :void {.inline.}=
  case P.kind
  of Kind.File : system.writeFile( toStr(P), data )
  of Kind.Dir  : PathError.trigger &"Tried to write data to a folder Path:  {P}"
  else         : PathError.trigger &"Tried to write to an invalid Path:  {P}"
#___________________
proc erase *(P :Path) :void {.inline.}=
  case P.kind
  of Kind.File : system.writeFile( toStr(P), "" )
  of Kind.Dir  : PathError.trigger &"Erasing a folder is not implemented yet:  {P}"
  else         : PathError.trigger &"Tried to erase an invalid Path:  {P}"


#_______________________________________
# @section PathHandle tools
#_____________________________
proc erase *(P :var PathHandle) :void=
  ## @descr
  ##  Deletes the -contents- of the file pointed to by the {@arg P} PathHandle object.
  ##  Does nothing if the file handle has not being opened yet.
  ## @note
  ##  Re-Opening the file in write mode has the effect of immediately clearing the file.
  ##  The file is kept open in append mode for normal use.
  if not isOpen(P): return
  discard P.handle.reopen(P.file.toStr, fmWrite)
  discard P.handle.reopen(P.file.toStr, P.mode)

