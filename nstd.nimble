#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
when not defined(nimscript): import system/nimscript # Silence nimsuggest errors
import std/[ os,strformat ]

#___________________
# Package
packageName   = "nstd"
version       = "0.5.33"
author        = "sOkam"
description   = "n*std | Non-Standard Nim stdlib Extensions"
license       = "MIT"
let gitURL    = &"https://github.com/heysokam/{packageName}"

#___________________
# Folders
srcDir       = "src"
binDir       = "bin"
let testsDir = "tests"
let docDir   = "doc"
let cacheDir = binDir/".cache"

#___________________
# Build requirements
requires "nim >= 1.9.1"
# requires "zippy"  # Silent requirement that must be managed by the user
# requires "puppy"  # Silent requirement that must be managed by the user


#________________________________________
# Helpers
#___________________
const vlevel = when defined(debug): 2 else: 1
const mode   = when defined(debug): "-d:debug" elif defined(release): "-d:release" elif defined(danger): "-d:danger" else: "-d:debug"
let nimcr = &"nimc c -r --verbosity:{vlevel} {mode} --hint:Conf:off --hint:Link:off --hint:Exec:off --nimCache:{cacheDir} --outdir:{binDir}"
  ## Compile and run, outputting to binDir
proc runFile (file, dir, args :string) :void=  exec &"{nimcr} {dir/file} {args}"
  ## Runs file from the given dir, using the nimcr command, and passing it the given args
proc runTest (file :string) :void=
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
  try: file.runFile("", "")
  except: echo &" └─ Failed to run one of the tests from  {file}"; quit()

#___________________
task push, "Internal:  Pushes the git repository, and orders to create a new git tag for the package, using the latest version.":
  ## Does nothing when local and remote versions are the same.
  requires "https://github.com/beef331/graffiti.git"
  exec "git push"  # Requires local auth
  exec &"graffiti ./{packageName}.nimble"
#___________________
task tests, "Internal:  Builds and runs all tests in the testsDir folder.":
  requires "pretty"
  for file in testsDir.listFiles():
    if file.lastPathPart.startsWith('t'):
      file.runtest()
#___________________
task docgen, "Internal:  Generates documentation using Nim's docgen tools.":
  echo &"{packageName}: Starting docgen..."
  exec &"nim doc --project --index:on --git.url:{gitURL} --outdir:{docDir}/gen src/{packageName}.nim"
  echo &"{packageName}: Done with docgen."

