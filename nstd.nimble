#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

#___________________
# Package
packageName   = "nstd"
version       = "0.1.1"
author        = "sOkam"
description   = "Non-Standard stdlib Extensions"
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

