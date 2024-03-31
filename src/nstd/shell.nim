#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/os import execShellCmd
import std/[ strformat,strutils ]
from std/symlinks import createSymlink
# @deps nstd
import ./logger as l
from ./paths import Path, setCurrentDir, removeFile, removeDir, dirExists


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
  proc rm *(file :string|Path)=  paths.removeFile(when file is Path: file else: file.Path)
  proc rmDir *(dir :string|Path)=  paths.removeDir(when dir is Path: dir else: dir.Path)
  template withDir *(trg :string|Path; body :untyped)=
    let prev = paths.getCurrentDir()
    l.dbg "Temporarily entering folder  ", when trg is Path: trg else: trg.string
    paths.setCurrentDir(when trg is Path: trg else: trg.string)
    body  # Run the code inside the block
    l.dbg "Returning to folder", prev
    paths.setCurrentDir(prev)
  #___________________
  import std/envvars
  export getEnv

#_______________________________________
# @section Commands
#___________________
proc sh *(cmd:string; args :varargs[string, `$`]) :void {.inline.}=
  let command = cmd & " " & args.join(" ")
  l.dbg "Executing command:\n  ", command
  try:
    when defined(nimscript): exec command
    else:
      if os.execShellCmd(command) != 0: raise newException(OSError, "")
  except: raise newException(OSError, &"Failed to run:  {command}")
#___________________
proc cp *(src,trg :string|Path) :void=
  when defined(nimscript) : cpFile(src, trg)
  else                    : os.copyFile(when src is Path: src.string else: src, when trg is Path: trg.string else: trg)
#___________________
proc mv *(src,trg :string|Path) :void=
  when defined(nimscript) : mvFile(src, trg)
  else                    : os.moveFile(when src is Path: src.string else: src, when trg is Path: trg.string else: trg)
#___________________
proc md *(trg :string|Path) :void {.inline.}=
  if dirExists(trg)       : l.dbg &"Folder already exists. Not creating:  {trg}"; return
  when defined(nimscript) : mkDir(trg)
  else                    : os.createDir( when trg is Path: trg.string else: trg )
#___________________
proc ln *(src,trg :string|Path; symbolic :bool= true) :void {.inline.}=
  ## @descr Creates a symbolic link from {@arg src} to {@arg trg}
  ## @todo Ignores {@arg symbolic} and only creates symbolic links. Should be able to handle both symbolic and hard links
  discard symbolic
  when defined(nimscript) : sh "ln", "-s", when src is Path: src.string else: src, when trg is Path: trg.string else: trg
  else                    : createSymlink( when src is Path: src else: src.Path, when trg is Path: trg else: trg.Path )
#___________________
proc dl *(args :varargs[string, `$`]) :void {.inline.}=
  when defined(nimscript) : sh "wget", args
  else                    : {.warning: "Downloading not implemented yet".} ; sh "wget", args
#___________________
proc unz *(args :varargs[string, `$`]) :void {.inline.}=
  var cmd :string
  for arg in args:
    if   ".zip" in arg: cmd = "unzip"; break
    elif ".tar" in arg: cmd = if defined(debug): "tar -xvf" else: "tar -xf"
  when defined(nimscript) : sh cmd, args
  else                    : {.warning: "Unzipping not implemented yet".} ; sh cmd, args
#___________________
proc git *(args :varargs[string, `$`]) :void {.inline.}=  sh "git", args

