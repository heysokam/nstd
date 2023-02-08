# std dependencies
import std/os
import std/strutils
# nstd dependencies
import ../types

#____________________________________
# File searching and checking
#_____________________________
proc touch *(trg :str) :void=  
  ## Creates the target file if it doesn't exist.
  ## When nimscript: Uses touch on linux and Get-Item on windows
  when nimvm:
    when defined linux:   exec &"touch {trg}"
    elif defined windows: exec &"Get-Item {trg}"
  else:  trg.open(mode = fmReadWriteExisting).close
#_____________________________
proc latestIn *(f, dir :str) :str=
  ## Finds the latest version of the file in dir, and returns its path.
  var files :seq[str]
  try:
    for it in dir.walkDirRec(checkDir=true):
      if f in it: files.add(it)
  except OSError: quit &"::ERR Tried to find latest version of {f}, but folder {dir} doesn't exist"
  result = files[^1]
#_____________________________
proc glob *(dir, pattern :string) :seq[string]=
  for file in dir.walkDir:
    if file.path.endsWith(pattern):
      result.add file.path

