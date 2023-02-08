# std dependencies
# nstd dependencies
import ../types

#____________________________________
# Removing (rm)
proc rm *(s :str)   :void= rmDir(s,checkDir=true); echo &":: Removed directory {s}"

proc rm *(s,t :str) :void=  #alias rm="rm -rf "
  case t:
  of "dir":  rm(s)
  of "file": rmFile(s); echo &":: Removed file {s}"
  else:      quit &"::ERR {t} is not a recognised type"


