#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Path management functions and extensions to `std/paths`
#  @TODO: Turn all of them into PathFile
when defined(nimscript):
  type Path * = string
else:
  # @deps std
  import std/os
  import std/paths   as stdPaths   ; export stdPaths
  import std/files   as stdFiles   ; export stdFiles
  import std/dirs    as stdDirs    ; export stdDirs
  import std/appdirs as stdAppDirs ; export stdAppDirs
  import std/hashes
  from std/strutils import splitLines, contains, replace, endsWith
  from std/sequtils import anyIt
  #_____________________________
  # Missing Procs
  proc len *(p :Path) :int {.borrow.}
  proc `$` *(p :Path) :string {.borrow.}
  proc `<` *(A,B :Path) :bool {.borrow.}
  proc staticRead *(p :Path) :string {.borrow.}
  proc readFile *(p :Path) :string {.borrow.}
  proc writeFile *(p :Path; data :string) :void {.borrow.}
  proc hash *(p :Path) :Hash {.borrow.}
  proc copyDirWithPermissions *(a,b :Path; ignorePermissionErrors = true) :void {.borrow.}
  proc getAppDir *() :Path=  os.getAppDir().Path
  proc contains *(trg :Path; data :string) :bool= trg.string.contains(data)
  proc contains *(trg,data :Path) :bool= trg.string.contains(data.string)
  proc replace *(trg :Path; A,B :string|Path) :Path= trg.string.replace(A.string, B.string).Path
  proc endsWith *(p :Path; A :char|string|Path) :bool= p.string.endsWith(A)
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
  #_____________________________
  proc appendFile *(trg :string|Path; data :string) :void=
    ## @descr Opens the {@arg trg} file and adds the {@arg data} contents to it without erasing the existing contents.
    let file = when trg is string: trg else: trg.string
    let F = file.open( fmAppend )
    F.write(data)
    F.close()
  #_____________________________
  proc readLines *(trg :string|Path) :seq[string]=  trg.readFile.splitLines
    ## @descr Reads the file and returns a seq[string] where is entry is a new line of the file
  #___________________
  const NonExtSuffixes = [".x64"]
  func stripFileExt *(path :Path) :Path=
    ## @descr Removes the file extension of {@arg path} only when its not a known Non-Extension suffix
    if NonExtSuffixes.anyIt( path.endsWith(it) ): return path
    result = path.changeFileExt("")
  #_____________________________
  # Modification time
  from std/times import `-`, inHours
  proc lastMod *(trg :string|Path) :times.Time=
    ## @descr Returns the last modification time of the {@arg trg} file, or empty if it cannot be found.
    try:    result = os.getLastModificationTime( trg.string )
    except: result = times.Time()
  #_____________________________
  proc noModSince *(trg :string|Path; hours :SomeInteger) :bool=  ( times.getTime() - trg.lastMod ).inHours > hours
    ## @descr Returns true if the {@arg trg} file hasn't been modified in the last N {@arg hours}.

  #_____________________________
  # Formatting: New Utilties
  #___________________
  func wrapped *(
      path   : Path;
      prefix : static string = "";
      strip  : static string = "";
    ) :string=
    ## @descr
    ##  Returns the {@arg path} as a string where each word is wrapped between "", and separated with {@link DirSep}
    ##  Adds the {@arg prefix} at the start of {@arg path}   (default: no prefix)
    ##  Removes any word that matches {@arg strip}           (default: strip nothing)
    # @note This function used to be clear and clean T_T
    let words = path.string.split(DirSep)
    if prefix != "": result.add prefix & $DirSep
    var skip :bool
    for id,val in words.pairs:
      if val == strip:
        if id == 0: skip = true
        continue
      if id != 0:
        if skip : skip = false
        else    : result.add DirSep
      result.add val.string.wrapped
  #___________________
  func wrapped *(
      list   : seq[Path];
      prefix : static string = "";
      strip  : static string = "";
    ) :seq[string]=
    ## @descr Returns the {@arg list} as a list of wrapped {@link Path}s.
    ## @see {@link wrapped[Path,string,string]}
    for file in list: result.add file.wrapped(prefix, strip)

