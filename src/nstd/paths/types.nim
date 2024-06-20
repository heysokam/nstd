#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path Types
#___________________________|
# @deps std
from std/os import nil
from std/paths as std import `/`, addFileExt
# @deps n*std
from ../errors import trigger
from ../strings import `&`

#_____________________________
type PathError * = object of CatchableError

#_____________________________
type Kind {.pure.}= enum
  Undefined
  Dir    ## @descr Path to a Directory
  File   ## @descr Path to a File
#___________________
const SomePath * = {Kind.Dir, Kind.File}

#_____________________________
type Path * = object
  ## @descr Data Type for a path, such that its pieces can be adjusted separately without issues.
  ## @field dir Absolute folder of the path
  ## @field sub Will be added after {@field dir}, becoming {@field dir}/{@field sub}
  ## @field name Basename of the file
  ## #field ext Extension of the file
  dir_p  :std.Path
  sub_p  :std.Path
  case kind :types.Kind
  of Kind.File:
    name_p :std.Path
    ext_p  :string
  else: discard
#___________________
type PathList * = seq[Path]
#_____________________________
const UndefinedPath * = Path(kind: Kind.Undefined)
  ## @descr Defines an Undefined Path, so that error messages are clearer. Mostly for error checking.

#_____________________________
type PathHandle * = object
  ## @descr Path to a file, its File handle and its opening mode
  file    *:Path
  handle  *:File
  mode    *:FileMode



#_______________________________________
# @section Path Constructors
#_____________________________
func newDir (
    dir : string|std.Path;
    sub : string|std.Path = std.Path"";
  ) :Path=
  result     = Path(kind: Kind.Dir)
  result.dir_p = when dir is std.Path: dir else: std.Path dir
  result.sub_p = when sub is std.Path: sub else: std.Path sub
#___________________
func newFile (
    dir  : string|std.Path;
    base : string|std.Path;
    sub  : string|std.Path = std.Path"";
  ) :Path=
  result      = Path(kind: Kind.File)
  result.dir_p  = when dir is std.Path: dir else: std.Path dir
  result.sub_p  = when sub is std.Path: sub else: std.Path sub
  result.name_p = std.Path os.splitFile(when base is Path: base.string else: base).name
  result.ext_p  = os.splitFile(when base is Path: base.string else: base).ext

