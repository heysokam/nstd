#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/os
import std/paths as stdPaths ; export stdPaths


#_____________________________
# Missing Procs
proc len        *(p :Path) :int    {.borrow.}
proc readFile   *(p :Path) :string {.borrow.}
proc fileExists *(p :Path) :bool   {.borrow.}
proc splitFile  *(p :Path) :tuple[dir, name, ext :string] {.borrow.}
proc `$` *(p :Path) :string {.borrow.}

#_____________________________
# Extend
const UndefinedPath * = "UndefinedPath".Path
  ## Path that defines an Undefined Path, so that error messages are clearer. Mostly for error checking.
#_____________________________
proc isFile *(input :string|Path) :bool=  (input.len < 32000) and (Path(input) != UndefinedPath) and (input.fileExists())
  ## Returns true if the input is a file. Returns false:
  ## : If the length of the path is too long
  ## : If the path == UndefinedPath
  ## : If the file does not exist
