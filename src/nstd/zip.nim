#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
import std/tables
# @deps external
import pkg/zippy/ziparchives
# @deps nstd
import ./strings
import ./shell
import ./paths


#_______________________________________
# @section Aliases for Paths
#_____________________________
proc extractAll *(zipPath, dest :Path) :void {.borrow.}
proc writeZipArchive *(archive :ZipArchive; path :Path) :void {.borrow.}


#_______________________________________
# @section Zipping
#_____________________________
proc zip *(list :seq[Path]; trg :Path; rel :Path= Path".") :void=
  ## @descr Zips the {@arg list} of files into the {@arg trg} file
  var entries: Table[string, string]
  withDir rel:
    for file in list:
      entries[file.relativePath(rel).string] = file.readFile
  trg.writeFile(createZipArchive(entries))


#_______________________________________
# @section Unzipping
#_____________________________
when not defined(nimscript):
  #_______________________________________
  # TODO: liblzma wrapper
  #     : https://github.com/tukaani-project/xz
  proc xunzip (file, trgDir :Path; subDir :Path= Path""; force :bool= false; verbose :bool= false) :void=
    ## @descr
    ##  UnZips the given tar compatible file into trgDir, calling `tar -xf` as an execShellCmd.
    ##  Extracts into current, and then moves the generated folder into trgDir
    let xDir   = trgDir.parentDir()  # Extract dir. The tar command will create a subdir in here.
    let resDir = xDir/subDir         # Resulting dir of the tar command.
    let tarxz  = if verbose: "tar -xvf" else: "tar -xf"
    let cmd    = &"{tarxz} {file} -C {xDir}"
    sh cmd
    resDir.copyDirWithPermissions(trgDir)
    resDir.removeDir
  #_______________________________________
  proc zunzip (file, trgDir :Path; subdir :Path= Path""; force :bool= false) :void=
    ## @descr
    ##  UnZips the given zippy compatible file into trgDir.
    ##  Stores contents in a temp folder and then copies them back into trgDir, and removes the temp folder.
    try: file.extractAll(trgDir)
    except ZippyError: # Destination exists, so we make a temp folder and manually move the files
      let tmpDir = trgDir/"temp"
      if dirExists(tmpDir): rmDir tmpDir
      file.extractAll(tmpDir)
      var xDir :Path
      if dirExists tmpDir/subDir: xDir = tmpDir/subDir
      else:  # silly case for zippy not understanding extraction, so .... search for it :facepalm:
        for dir in tmpDir.walkDir:
          if dir.path.dirExists() and subDir.string in dir.path.string:
            xDir = dir.path
      cpDir xDir, trgDir
      rmDir tmpDir

#_______________________________________
proc unz *(file, trgDir :Path; verbose :bool= false) :void=
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
    let subDir = file.lastPathPart.splitFile.name.splitFile.name  # Basename of the file, without extensions
    if file.string.endsWith(".tar.xz"): file.xunzip(trgDir, subDir, verbose)
    else: file.zunzip(trgDir, subDir, verbose)

