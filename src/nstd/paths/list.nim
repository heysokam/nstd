#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/os import nil
import std/importutils as imp
# @deps n*std
import ../strings
import ../errors
# @deps n*std.paths
import ./types {.all.} as paths
imp.privateAccess(paths.Path)
import ./core/access
import ./core/create
import ./both



#____________________________________________________
# TODO:
# proc getFileList *(src :seq[DirFile]; dir :Path= cfg.srcDir; rel :bool= false) :seq[Path]=
#   ## @descr
#   ##  Returns {@arg src} as a list of paths
#   ##  Will be relative to {@arg dir} when {@arg rel} is true
#   for file in src:
#     if rel : result.add file.path.relativePath(dir)
#     else   : result.add file.path
#____________________________________________________



#_______________________________________
# @section Path List Management
#_____________________________
func join *(
    list : PathList;
    sep  : string = " ";
  ) :string=
  ## @descr Converts the {@arg list} Paths into a single string containing all their paths merged together, separated by {@arg sep}
  for id,P in list.pairs:
    result.add P.path
    if id != list.high: result.add sep
#___________________
proc chgDir *(
    list : PathList;
    to   : string;
    sub  : string= "";
  ) :PathList {.inline.}=
  ## @descr
  ##  Returns a new {@link Path} list, based on {@arg list}, with its directory changed to {@arg to}.
  ##  Will change the {@link Path.sub} field of each entry when {@arg sub} is provided.
  for P in list: result.add P.chgDir(to,sub)


#_____________________________
# @section Glob Creation
#___________________
func shouldSkip (filters :openArray[string]; file :string) :bool=
  for filter in filters:
    if filter in file: return true
#___________________
proc glob *(
    dir     : string;
    ext     : string            = ".c";
    rec     : bool              = false;
    filters : openArray[string] = @[];
  ) :PathList=
  ## @descr
  ##  Globs every file in the {@arg P} folder that has the given ext.
  ##  {@arg ext}     Extension to search for.  (default: `.c`)
  ##  {@arg rec}     Recursive search in all folders and subfolders when true. Default: `false`
  ##  {@arg filters} List of paths that will be used to exclude/filter out files that contain any of them
  if rec:
    for file in os.walkDirRec(dir):
      if filters.shouldSkip(file): continue
      if strings.endsWith(file, ext): result.add Path.new(dir, base= file.replace(dir, "") )
  else:
    for file in os.walkDir(dir):
      if filters.shouldSkip(file.path): continue
      if strings.endsWith(file.path.string, ext): result.add Path.new(dir, base= file.path.replace(dir, "") )
#___________________
proc glob *(
    P       : Path;
    ext     : string            = ".c";
    rec     : bool              = false;
    filters : openArray[string] = @[];
  ) :PathList=
  ## @descr
  ##  Globs every file in the {@arg P} folder that has the given ext.
  ##  {@arg ext}     Extension to search for.  (default: `.c`)
  ##  {@arg rec}     Recursive search in all folders and subfolders when true. Default: `false`
  ##  {@arg filters} List of paths that will be used to exclude/filter out files that contain any of them
  if P.kind != Kind.Dir: PathError.trigger &"Tried to glob the list of files from an invalid folder:  {P}"
  result = P.path.glob(ext,rec,filters)

