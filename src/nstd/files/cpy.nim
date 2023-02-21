#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/os
import std/strformat
# nstd dependencies
import ../types
import ./make
import ./search

#____________________________________
proc cp *(src, dir, typ :str)=  #alias cp="cp -v "
  ## Copies src to dir.
  ## Creates directories automatically if the target dir doesn't exist.
  dir.checkOrMkDir
  try:
    case typ:
    of "dir":
      when defined(nimscript): src.cpDir(dir)    #;  echo &":: Copied dir {s} to {d}"
      else:                    src.copyDir(dir)
    of "file":
      when defined(nimscript): src.cpFile(dir)   #; echo &":: Copied file {s} to {d}"
      else:                    src.copyFile(dir)
    #of "ftodir":  copyFileToDir(s,d); echo &":: Copied file {s} to dir {d}"
  except OSError:  quit &"::ERR Failed to copy {src} to {dir}"

#____________________________________
proc cp *(src, dir :str) :void=
  ## Copies src to dir.
  ## Creates directories automatically if the target dir doesn't exist.
  ## Assumes copying file to folder when type is omitted
  let file = src.splitFile().name & src.splitFile().ext # Extract file name+ext
  cp src, dir/file, "file" # copy source to dest/name

#____________________________________
proc cpLatest *(dir, file, trg :str)  :void=
  ## Copy latest version of dir/file into targetDir
  cp file.latestIn(dir), trg

proc cpLatest *(dir, file, trgDir,trgFile :str) :void=
  ## Copy latest version of dir/file into targetDir/targetFile
  cp file.latestIn(dir), trgDir/trgFile, "file"


#TODO: remove bash dependency
#____________________________________
proc cpBkp *(s,d :str) :void=
  checkOrMkDir(d)
  try:             exec &"cp -vu --backup=t {s} {d}"; echo &":: Created {s} backup file inside {d}"
  except OSError:  quit &"::ERR Failed to backup {s} to {d}"

proc cpUpd *(s,d :str) :void=
  checkOrMkDir(d)
  try:             exec &"cp -vu {s} {d}"; echo &":: Copied {s} to {d}"
  except OSError:  quit &"::ERR Failed to copy {s} to {d}"

##[  TODO
#________________________________________
proc cp *(src, trg :string) :void=
  # Get src file objects info
  if not src.dirExists and not src.fileExists: return
  let sinfo = src.getFileInfo(true)
  let srcf  = sinfo.kind == pcFile or sinfo.kind == pcLinkToFile  # src is file or link to file
  let srcd  = sinfo.kind == pcDir  or sinfo.kind == pcLinkToDir   # src is dir  or link to dir
  # Get trg file objects info
  let tinfo = trg.getFileInfo(true)
  let trgf  = tinfo.kind == pcFile or tinfo.kind == pcLinkToFile  # trg is file or link to file
  let trgd  = tinfo.kind == pcDir  or tinfo.kind == pcLinkToDir   # trg is dir  or link to dir 
  # Do the copying
  if   srcf and trgf: copyFile src, trg
  elif srcf and trgd: copyFileToDir src, trg
  elif srcd and trgd: copyDir src, trg
  else: return
]##


