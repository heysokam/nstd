#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/os import execShellCmd, removeFile, removeDir, dirExists, fileExists, walkDir, pcFile, pcDir
from std/symlinks import createSymlink
from std/strutils import join
# @deps nstd
import ./logger as l
import ./paths
from ./strings import `&`


#_______________________________________
# @section Request inputs from the user
#_____________________________
when not defined(nimscript):
  proc request *(msg :string; alt :string= "") :string=
    # Report the {@arg msg} to the user
    echo msg
    # Get the line
    result = readLine(stdin)
    if result == "": result = alt
  #___________________
  proc request *(_:typedesc[char]; msg :string; alt :char= ' ') :char=
    # Report the {@arg msg} to the user
    echo msg
    # Get the character
    var ch = readChar(stdin)
    result = ch
    if result == '\n': result = alt
    # Clear stdin of leftover characters
    while ch != '\n': ch = readChar(stdin)


#_______________________________________
# @section Nimscript compatibility for compiled code
#___________________
when not defined(nimscript):
  template rm *(P :Path) :void= P.remove
  template withDir *(trg :string|Path; body :untyped)=
    let prev = paths.getCurrentDir()
    l.dbg &"Temporarily entering folder  " & $trg
    paths.setCurrentDir(when trg is Path: trg else: paths.newDir(dir))
    body  # Run the code inside the block
    l.dbg &"Returning to folder  " & $prev
    paths.setCurrentDir(prev)
  #___________________
  import std/envvars
  export getEnv

#_______________________________________
# @section Commands
#___________________
proc sh *(cmd:string; args :varargs[string, `$`]) :void {.inline.}=
  let command = &"{cmd}" & args.join(" ")
  l.dbg "Executing command:\n  ", command
  try:
    when defined(nimscript): exec command
    else:
      if os.execShellCmd(command) != 0: raise newException(OSError, "")
  except: raise newException(OSError, &"Failed to run:  {command}")
#___________________
proc cp *(src,trg :string|Path) :void=
  when src is string and trg is string:
    if os.fileExists(src) :
      when defined(nimscript) : cpFile(src, trg)
      else                    : os.copyFile(src, trg)
    elif os.dirExists(src)    :
      when defined(nimscript) : cpDir(src, trg)
      else                    : os.copyDir(src, trg)
  elif src is Path and trg is Path:
    cp src.path, trg.path
  else: unreachable
#___________________
proc cpDir *(src,trg :string|Path; filter :openArray[string|Path]) :void=
  ## @descr Alternative {@link cpDir} that supports passing a list of {@arg filter} paths to ignore
  for it in src.walkDir:
    when src is string:
      if it.path in filter: continue
      if   it.kind == pcFile : cp    it.path, trg/it.path.relativePath(src)
      elif it.kind == pcDir  : cpDir it.path, trg
      else: discard
    else:
      if it in filter: continue
      cp it, it.relative(src).chgDir(trg)
#___________________
proc mv *(src,trg :string|Path) :void=
  when defined(nimscript) : mvFile(src, trg)
  else                    : os.moveFile(when src is Path: src.string else: src, when trg is Path: trg.string else: trg)
#___________________
proc md *(trg :Dir) :void {.inline.}=
  if trg.exists : l.dbg &"Folder already exists. Not creating:  {trg}"; return
  trg.create
#___________________
proc ln *(src,trg :string|Path; symbolic :bool= true) :void {.inline.}=
  ## @descr Creates a symbolic link from {@arg src} to {@arg trg}
  ## @todo Ignores {@arg symbolic} and only creates symbolic links. Should be able to handle both symbolic and hard links
  discard symbolic
  when defined(nimscript) : sh "ln", "-s", when src is Path: src.string else: src, when trg is Path: trg.string else: trg
  else                    : createSymlink( when src is Path: src else: src.Path, when trg is Path: trg else: trg.Path )
#___________________
proc touch *(trg :string|Path) :void=
  ## @descr Creates the target file if it doesn't exist.
  when defined(nimscript) :
    when defined linux    : exec &"touch {trg}"
    elif defined windows  : exec &"powershell \"Get-Item {trg}\""
  else                    : open(when trg is Path: trg.string else: trg mode = fmAppend).close





##[
#_______________________________________
# @section Reference: Old Python-like Tools
#_____________________________
# Zipping
proc zip_priv (s:string,d:string)= # Zips files literally (absolute or relative, whatever is passed) (internal use only)
  try:             exec &"zip -vr {d} {s}"; echo &":: Created zip file {d} from the contents of {s}"
  except OSError:  quit &"::ERR Failed to create zip file {d} from {s}"

proc zipAbs *(s:string,d:string)= zip_priv s, d

proc zip *(s :seq[string]; d :string)=  #alias zip="zip -v ", but for Sequences of strings (file lists)
  var tseq=s
  echo &":: Splitting list of files {s}"
  for it in mitems(tseq): it = it.relativePath(getCurrentDir()); echo &": {it}"
  let t = tseq.join(" ")
  zip_priv t, d

proc zip*(s:string,d:string)=
  ## alias zip="zip -v "
  let t = s.split(" "); zip t, d

proc zipd_priv (trg,zfile :string) :void=
  ## @internal
  ## @descr Removes files from target zip file
  try:             exec &"zip -vd {zfile} {trg}"; echo &":: Deleted {trg} file from the contents of {zfile}"
  except OSError:  quit &"::ERR Failed to delete file {trg} from {zfile}"

proc zipd *(trg,zfile :string) :void= zipd_priv s, d
  ## @descr Removes files from target zip file
  ## alias zipd="zip -vd"
]##

