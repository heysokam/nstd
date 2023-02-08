#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/os
# nstd dependencies
import ../types
import ./make
import ./search

#____________________________________
# Copying
proc cp *(src, dir, typ :str)=  #alias cp="cp -v "
  ## Copies src to dir.
  ## Creates directories automatically if the target dir doesn't exist.
  dir.checkOrMkDir
  try:
    when nimvm:
      case typ:
      of "dir":   src.cpDir(dir)#;  echo &":: Copied dir {s} to {d}"
      of "file":  src.cpFile(dir)#; echo &":: Copied file {s} to {d}"
      #of "ftodir":  copyFileToDir(s,d); echo &":: Copied file {s} to dir {d}"
    else:
      case typ:
      of "dir":   src.copyDir(dir)#;  echo &":: Copied dir {s} to {d}"
      of "file":  src.copyFile(dir)#; echo &":: Copied file {s} to {d}"
      #of "ftodir":  copyFileToDir(s,d); echo &":: Copied file {s} to dir {d}"
  except OSError:  quit &"::ERR Failed to copy {s} to {d}"

proc cp *(s,d :str) :void=  # Assume copying file to folder when type is omitted
  let n = s.splitFile().name & s.splitFile().ext # Extract file name+ext
  cp s, d/n, "file" # copy source to dest/name

proc cpBkp *(s,d :str) :void=
  checkOrMkDir(d)
  try:             exec &"cp -vu --backup=t {s} {d}"; echo &":: Created {s} backup file inside {d}"
  except OSError:  quit &"::ERR Failed to backup {s} to {d}"

proc cpUpd *(s,d :str) :void=
  checkOrMkDir(d)
  try:             exec &"cp -vu {s} {d}"; echo &":: Copied {s} to {d}"
  except OSError:  quit &"::ERR Failed to copy {s} to {d}"

proc cpLatest *(d,f, t :str)    :void=  cp f.latestIn(d), t             # Copy latest version of dir/file into targetDir
proc cpLatest *(d,f, td,t :str) :void=  cp f.latestIn(d), td/t, "file"  # Copy latest version of dir/file into targetDir/targetFile


