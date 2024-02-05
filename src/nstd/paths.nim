#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path management functions and extensions to `std/paths`
when defined(nimscript):
  type Path * = string
else:
  # @deps std
  import std/os
  import std/paths as stdPaths ; export stdPaths
  import std/files as stdFiles ; export stdFiles
  import std/dirs  as stdDirs  ; export stdDirs
  import std/hashes
  #_____________________________
  # Missing Procs
  proc len *(p :Path) :int    {.borrow.}
  proc `$` *(p :Path) :string {.borrow.}
  proc staticRead *(p :Path) :string {.borrow.}
  proc readFile *(p :Path) :string {.borrow.}
  proc writeFile *(p :Path; data :string) :void {.borrow.}
  proc hash *(p :Path) :Hash {.borrow.}
  #_____________________________
  # Extend
  const UndefinedPath * = "UndefinedPath".Path
    ## @descr Path that defines an Undefined Path, so that error messages are clearer. Mostly for error checking.
  #_____________________________
  func `/` *(p :Path; s :string) :Path=  p/s.Path
  func `/` *(s :string; p :Path) :Path=  s.Path/p
  #_____________________________
  proc isFile *(input :string|Path) :bool=  (input.len < 32000) and (Path(input) != UndefinedPath) and (input.fileExists())
    ## @descr Returns true if the input is a file.
    ##  Returns false:
    ##  : If length of the path is too long
    ##  : If path == UndefinedPath
    ##  : If file does not exist
  #_______________________________________
  proc appendFile *(trg :string|Path; data :string) :void=
    ## @descr Opens the {@arg trg} file and adds the {@arg data} contents to it without erasing the existing contents.
    let file = when trg is string: trg else: trg.string
    file.open( fmAppend ).write(data).close()

