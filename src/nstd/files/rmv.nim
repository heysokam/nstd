#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/os
import std/strformat
# nstd dependencies
import ../types

#____________________________________
# Removing (rm)
proc rm *(src, typ :str) :void=  #alias rm="rm -rf "
  try:
    case typ:
    of "dir":  
      when defined(nimscript):  src.rmDir(checkDir=true)     ; echo &":: Removed directory {src}"
      else:                     src.removeDir(checkDir=true) ; echo &":: Removed directory {src}"
    of "file": 
      when defined(nimscript):  src.rmFile     ; echo &":: Removed file {src}"
      else:                     src.removeFile ; echo &":: Removed file {src}"
    else: quit &"::ERR {typ} is not a recognised type"
  except OSError:  quit &"::ERR Failed to remove {src}"

proc rm *(src :str) :void= src.rm("file")
  


