#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path Directories
#_________________________________|
# @desp std
from std/os import nil
from std/macros as m import nil


#____________________________________________________
# TODO:
# proc getAppDir *() :Path=  os.getAppDir().Path
# TODO: Convert the templates into Path
#____________________________________________________


#_______________________________________
# @section Paths: Directory Names
#_____________________________
template thisDir *() :string=  os.parentDir( instantiationInfo(fullPaths = true).fileName )
  ## @descr Returns the folder of the current source file path where this template is called from.
template thisFile *() :string=  instantiationInfo(fullPaths = true).fileName
  ## @descr Returns the current source file path where this template is called from.
#_____________________________
func projectDir *() :string {.inline.}=
  ## @warning Broken when not nimvm
  ## @descr
  ##  Returns the path where the main file being used is stored.
  ##  Unlike `thisDir`, it will always return the same root dir, even if called from an imported file.
  ##  Combined alias for nimvm.projectDir() and compiled.getProjectPath()
  when nimvm: projectDir()
  else:       m.getProjectPath()

