#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________


import ./nstd/types     ; export types     ## System type aliases
import ./nstd/address   ; export address   ## Mem Addresses tools
import ./nstd/alias     ; export alias     ## System proc aliases
import ./nstd/compile   ; export compile   ## Nim as Buildsystem system tools
import ./nstd/convert   ; export convert   ## Type conversion tools
import ./nstd/dirs      ; export dirs      ## Tools for dir management
import ./nstd/format    ; export format    ## Tools for formatting of text on console and logs
import ./nstd/git       ; export git       ## Tools for git management
import ./nstd/iter      ; export iter      ## Extra Iterators
import ./nstd/logger    ; export logger    ## Logging interface for functionality from other tools
import ./nstd/macros    ; export macros    ## Extra Macros
import ./nstd/node      ; export node      ## Node type and functionality
import ./nstd/size      ; export size      ## Size tools
import ./nstd/time      ; export time      ## Ergonomic helpers for managing time
import ./nstd/typetools ; export typetools ## General tools for managing types


# WRN
# ./nstd/auto is not exported automatically. 
# Converters and automatic behavior are dangerous.
# But sometimes they are helpful, so for those cases the functionality is there.
# It should be explicitely imported where its used, with:
import nstd/auto  ## Converters (automatic or non-explicit behavior)

