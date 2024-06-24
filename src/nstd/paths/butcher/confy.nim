



#_____________________________
# @section Remotes Management
#___________________
proc fromRemote *(
    list : PathList;
    dir  : Dir;
    sub  : Dir = Dir("");
  ) :PathList=
  ## @descr
  ##  Adjusts the input list of source files to be searched from `srcDir/subDir` first by default.
  ##  This is needed to remap a remote glob into srcDir/, so the files are searched inside the local folder first.
  result = list.remap(dir/sub)  # readability alias for remap
#_____________________________
proc globRemote *(
    dir : Dir;
    ext : string = ".c";
    rec : bool   = false;
    sub : Dir    = Dir("")
  ) :PathList=
  ## @descr
  ##  Globs every file that has the given `ext` in the input remote `dir`.
  ##  Returns the list of files, adjusted so they are searched from `cfg.srcDir` first.
  ##  `ext` the extension to search for. Default: `.c`
  ##  `rec` recursive search in all folders and subfolders when true. Default: `false`
  result = dir.glob(ext, rec).fromRemote(dir, sub)

