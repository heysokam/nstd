#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________

#___________________
# Package
packageName   = "nstd"
version       = "0.0.0"
author        = "sOkam"
description   = "Nim Non-Standard stdlib Extensions"
license       = "MIT"


#___________________
# Folders
srcDir           = "src"
binDir           = "bin"
let testsDir     = "tests"
let examplesDir  = "examples"
let docDir       = "doc"
skipdirs         = @[binDir, examplesDir, testsDir, docDir]


#___________________
# Build requirements
requires "nim >= 1.6.12"   ## Latest stable version
# taskRequires "test", "print"  ## Require treeform/print only for tests


#________________________________________
# Helpers
#___________________
import std/os
import std/strformat
#___________________
let nimcr = &"nimble c -r --outdir:{binDir}"
  ## Compile and run, outputting to binDir
proc runFile (file, dir :string) :void=  exec &"{nimcr} {dir/file}"
  ## Runs file from the given dir, using the nimcr command
proc runTest (file :string) :void=  file.runFile(testsDir)
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
proc runExample (file :string) :void=  file.runFile(examplesDir)
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder

