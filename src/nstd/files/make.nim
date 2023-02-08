# std dependencies
import std/os
# nstd dependencies
import ../types

#____________________________________
# Make Directories (md)
proc md *(d :str)=  #alias md="mkdir -v "
  if dirExists(d): echo &":: Directory {d} already exists. Ignoring its creation."; return
  try:             mkDir(d)#; echo &":: Created directory {d}"
  except OSError:  quit &"::ERR Failed to make directory {d}"
proc md *(d :str; o :bool) :str=  md(d); result = if o: d else: ""  # Alias for creation and also assignment to variables
proc checkOrMkDir *(f:str)=
  let d=splitFile(f).dir; if not dirExists(d): md d



