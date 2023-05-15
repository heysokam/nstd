#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# std dependencies
import std/os
import std/macros


#_____________________________
template thisDir *() :string=  currentSourcePath().parentDir
  ## Returns the current source file path where this template is called from.

#_____________________________
template projectDir *() :string=
  ## Returns the path where the main file being used is stored.
  ## Unlike `thisDir`, it will always return the same root dir,
  ## even if called from an imported file.
  when nimvm: projectDir()
  else:       getProjectPath()
