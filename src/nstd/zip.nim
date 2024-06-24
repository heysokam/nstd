#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
import std/tables
# @deps external
import pkg/zippy/ziparchives as z
# @deps nstd
import ./strings
import ./shell
import ./paths


#_______________________________________
# @section Aliases for Paths
#_____________________________
proc extract *(zipPath, dest :Path) :void= z.extractAll(zipPath.path, dest.path)
proc writeZipArchive *(archive :z.ZipArchive; P :Path) :void=
  z.writeZipArchive(archive, P.path)


#_______________________________________
# @section Zipping
#_____________________________
proc zip *(
    list : PathList;
    trg  : Fil;
    rel  : Dir = paths.getCurrentDir();
  ) :void=
  ## @descr Zips the {@arg list} of files into the {@arg trg} file
  var entries: Table[string, string]
  withDir rel:
    for file in list:
      entries[file.relative(rel).path] = file.read
  trg.path.writeFile(z.createZipArchive(entries))
#_____________________________
proc zip *(
    dir : Dir;
    trg : Fil;
    rel : Dir = paths.getCurrentDir()
  ) :void=
  ## @descr Zips the {@arg dir} folder into the {@arg trg} file
  var entries: Table[string, string]
  withDir rel:
    for file in dir.walkRec:
      entries[file.relative(rel).path] = file.read
  trg.path.writeFile(z.createZipArchive(entries))


#_______________________________________
# @section Unzipping
#_____________________________
when not defined(nimscript):
  #_______________________________________
  # TODO: liblzma wrapper
  #     : https://github.com/tukaani-project/xz
  proc xunzip (
      file    : Fil;
      trgDir  : Dir;
      subDir  : string = "";
      force   : bool   = false;
      verbose : bool   = false
    ) :void=
    ## @descr
    ##  UnZips the given tar compatible file into trgDir, calling `tar -xf` as an execShellCmd.
    ##  Extracts into current, and then moves the generated folder into trgDir
    let xDir   = trgDir.parent()  # Extract dir. The tar command will create a subdir in here.
    let resDir = xDir/subDir      # Resulting dir of the tar command.
    let tarxz  = if verbose: "tar -xvf" else: "tar -xf"
    let cmd    = &"{tarxz} {file} -C {xDir}"
    sh cmd
    resDir.copyWithPermissions(trgDir)
    resDir.remove
  #_______________________________________
  proc zunzip (
      file   : Fil;
      trgDir : Dir;
      subDir : string = "";
      force  : bool   = false
    ) :void=
    ## @descr
    ##  UnZips the given zippy compatible file into trgDir.
    ##  Stores contents in a temp folder and then copies them back into trgDir, and removes the temp folder.
    try: file.extract(trgDir)
    except z.ZippyError: # Destination exists, so we make a temp folder and manually move the files
      let tmpDir = trgDir/"temp"
      if tmpDir.exists: tmpDir.remove
      file.extract(tmpDir)
      var xDir :Path
      if exists tmpDir/subDir: xDir = tmpDir/subDir
      else:  # silly case for zippy not understanding extraction, so .... search for it :shrug:
        for dir in tmpDir.walk:
          if dir.exists and subDir in dir.path:
            xDir = dir
      cp xDir, trgDir
      rm tmpDir

#_______________________________________
proc unz *(
    file    : Fil;
    trgDir  : Dir;
    verbose : bool = false;
  ) :void=
  ## @descr
  ##  UnZips the given file into trgDir, based on its extension.
  ##  Will use tar -xf for tar.xz and zippy for any other filetype
  when defined(nimscript):
    var cmd :string
    for arg in args:
      if   ".zip" in arg: cmd = "unzip"; break
      elif ".tar" in arg: cmd = if defined(debug): "tar -xvf" else: "tar -xf"
    sh cmd, args
  else:
    let subDir = file.name # file.lastPathPart.splitFile.name.splitFile.name  # Basename of the file, without extensions
    if ".tar.xz" in file.ext: file.xunzip(trgDir, subDir, verbose)
    else: file.zunzip(trgDir, subDir, verbose)

