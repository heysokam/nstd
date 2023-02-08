#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
# nstd dependencies
import ../types

#____________________________________
# Moving (mv)
proc mv *(s,d,t :str) :void=  #alias mv="mv -v "
  try:
    case t:
    of "dir":  mvDir(s,d)#;  echo &":: Moved dir {s} to {d}"
    of "file": mvFile(s,d)#; echo &":: Moved file {s} to {d}"
    else:      quit &"::ERR {t} is not a recognised type"
  except OSError:  quit &"::ERR Failed to move {s} to {d}"
proc mv *(s,d :str) :void= mv s, d, "file"  # Assume file when type is omitted

