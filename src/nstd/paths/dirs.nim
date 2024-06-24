#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path Directories
#_________________________________|
# @desp std
from std/os import `/`
from std/macros as m import nil
import std/importutils as imp
# @deps n*std
from ../markers import unreachable
import ../errors
import ../strings
import ../logger as l
# @deps n*std.paths
import ./types {.all.} as paths
imp.privateAccess(paths.Path)
import ./core/access
import ./core/validate


#_______________________________________
# @section Editing
#_____________________________
proc create *(dir :Dir) :void=
  if dir.kind != paths.Kind.Dir: PathError.trigger &"Tried to create a folder, but its path is incorrect:  {dir}"
  if dir.exists           : l.dbg &"Folder already exists. Not creating:  {dir}"; return
  when defined(nimscript) : mkDir(trg.path)
  else                    : os.createDir(dir.path)


#_______________________________________
# @section Paths: Directory Names
#_____________________________
template thisDir *() :Dir=  paths.newDir( os.parentDir( instantiationInfo(fullPaths = true).fileName ) )
  ## @descr Returns the folder of the current source file path where this template is called from.
template thisFile *() :Fil=
  ## @descr Returns the current source file path where this template is called from.
  let N = instantiationInfo(fullPaths = true).fileName
  paths.newFile(dir= os.parentDir(N), base= os.lastPathPart(N))
#_____________________________
when not defined(nimscript): from system/nimscript as ns import nil
func projectDir *() :Dir {.inline.}=
  ## @warning Broken when not nimvm
  ## @descr
  ##  Returns the path where the main file being used is stored.
  ##  Unlike `thisDir`, it will always return the same root dir, even if called from an imported file.
  ##  Combined alias for nimvm.projectDir() and compiled.getProjectPath()
  when nimvm: paths.newDir( ns.projectDir() )
  else:       paths.newDir( m.getProjectPath() )
#_____________________________
proc getAppDir     *() :Dir {.inline.}= paths.newDir(os.getAppDir())
proc setCurrentDir *(P :Dir) :void {.inline.}= os.setCurrentDir( P.path )
proc getCurrentDir *() :Dir {.inline.}= paths.newDir( os.getCurrentDir() )


#_______________________________________
# @section Paths: Directory Iterators
#_____________________________
iterator walkRec *(P :Dir) :Path=
  for entry in os.walkDirRec(P.dirSub):
    let F = os.splitFile(entry)
    if   os.fileExists(entry) or F.ext != "" : yield paths.newFile(F.dir, F.name&F.ext)
    elif os.dirExists(entry)  or F.ext == "" : yield paths.newDir(F.dir/F.name)
    else                                     : unreachable
#___________________
iterator walk *(P :Dir) :Path=
  for (kind,entry) in os.walkDir(P.dirSub):
    let F = os.splitFile(entry)
    if   os.fileExists(entry) or F.ext != "" : yield paths.newFile(F.dir, F.name&F.ext)
    elif os.dirExists(entry)  or F.ext == "" : yield paths.newDir(F.dir/F.name)
    else                                     : unreachable

