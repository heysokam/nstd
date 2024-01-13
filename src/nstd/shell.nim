#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/os import execShellCmd
import std/[ strformat,strutils ]
# @deps nstd
import ./logger as l
from ./paths import Path, setCurrentDir

#_______________________________________
# @section Nimscript compatibility for compiled code
#___________________
when not defined(nimscript):
  template rm *(file :string|Path)=  paths.removeFile(when file is Path: file else: file.Path)
  template rmDir *(dir :string)=  paths.removeDir(dir)
  template withDir *(trg :string|Path; body :untyped)=
    let prev = paths.getCurrentDir()
    l.dbg "Temporarily entering folder", when trg is Path: trg else: trg.string
    paths.setCurrentDir(when trg is Path: trg else: trg.string)
    body  # Run the code inside the block
    l.dbg "Returning to folder", prev
    paths.setCurrentDir(prev)

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
proc cp *(src,trg :string) :void=
  when defined(nimscript) : cpFile(src, trg)
  else                    : os.copyFile(src, trg)
proc mv *(src,trg :string) :void=
  when defined(nimscript) : mvFile(src, trg)
  else                    : os.moveFile(src, trg)
proc md *(trg :string|Path) :void {.inline.}=
  when defined(nimscript) : mkDir(trg)
  else                    : os.createDir( when trg is Path: trg.string else: trg )
proc dl *(args :varargs[string, `$`]) :void {.inline.}=
  when defined(nimscript) : sh "wget", args
  else                    : {.warning: "Downloading not implemented yet".} ; sh "wget", args
proc unz *(args :varargs[string, `$`]) :void {.inline.}=
  var cmd :string
  for arg in args:
    if   ".zip" in arg: cmd = "unzip"; break
    elif ".tar" in arg: cmd = if defined(debug): "tar -xvf" else: "tar -xf"
  when defined(nimscript) : sh cmd, args
  else                    : {.warning: "Unzipping not implemented yet".} ; sh cmd, args
proc git *(args :varargs[string, `$`]) :void {.inline.}=  sh "git", args

