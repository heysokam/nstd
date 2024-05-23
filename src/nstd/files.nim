#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
import std/paths
import std/files
# @deps n*std
import ./types


#_______________________________________
# @section PathFile tools
#_____________________________
proc new *(_:typedesc[PathFile]; path :Path; mode :FileMode) :PathFile=
  ## @descr
  ##  Creates a new PathFile object from the given file path and mode.
  ##  Its handle will remain open with the given mode, and will need to be closed after use.
  result.path   = path
  result.mode   = mode
  result.handle = result.path.open(result.mode)

#_______________________________________
proc isOpen *(file :PathFile) :bool=  not file.handle.isNil
proc exists *(file :PathFile) :bool=  file.path.fileExists()

#_______________________________________
proc erase *(file :var PathFile) :void=
  ## @descr
  ##  Deletes the -contents- of the given PathFile object.
  ##  Does nothing if the file handle has not being opened yet.
  ## @note
  ##  Re-Opening the file in write mode has the effect of immediately clearing the file.
  ##  The file is kept open in append mode for normal use.
  if not file.isOpen: return
  discard file.handle.reopen(file.path.string, fmWrite)
  discard file.handle.reopen(file.path.string, file.mode)

