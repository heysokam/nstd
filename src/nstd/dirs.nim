#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/macros


##[_____________________________
import std/os  # for parentDir()
template thisDir *() :string=  currentSourcePath().parentDir()
  ## Returns the current source file path where this template is called from.
  ## NOTE: Should be implemented in every compiled file, only for reference
  ##     : nimscript has it as a native function
]###_____________________________


#_____________________________
func projectDir *() :string {.inline.}=
  ## Returns the path where the main file being used is stored.
  ## Unlike `thisDir`, it will always return the same root dir, even if called from an imported file.
  ## Combined alias for nimvm.projectDir() and compiled.getProjectPath()
  when nimvm: projectDir()
  else:       getProjectPath()

