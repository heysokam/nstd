#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/os
import std/strformat
# nstd dependencies
import ../types

#____________________________________
# Make Directories (md)
proc md *(trg :str) :void=  #alias md="mkdir -v "
  if trg.dirExists: echo &":: Directory {trg} already exists. Ignoring its creation."; return
  try:
    when defined(nimscript):
      trg.mkDir()      #; echo &":: Created directory {d}"
    else:
     trg.createDir()  #; echo &":: Created directory {d}"
  except OSError:  quit &"::ERR Failed to make directory {trg}"

proc checkOrMkDir *(trg :str) :void=
  let dir = trg.splitFile.dir
  if not dir.dirExists: md dir

