#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________

import ./nstd/types   ; export types     ## System type aliases
import ./nstd/procs   ; export procs     ## System proc aliases
import ./nstd/refs    ; export refs      ## System ref extensions
import ./nstd/dirs    ; export dirs      ## Tools for dir management
import ./nstd/convert ; export convert   ## Type conversion tools
import ./nstd/iter    ; export iter      ## Extra Iterators
import ./nstd/macros  ; export macros    ## Extra Macros
import ./nstd/C       ; export C         ## C interoperability tools
import ./nstd/logger  ; export logger    ## Logging interface for functionality from other tools
import ./nstd/format  ; export format    ## Tools for formatting of text on console and logs
import ./nstd/time    ; export time      ## Ergonomic helpers for managing time
import ./nstd/node    ; export node      ## Node type and functionality

# WRN
# ./nstd/auto is not exported automatically. 
# Converters and automatic behavior are dangerous.
# But sometimes they are helpful, so for those cases the functionality is there.
# It should be explicitely imported where its used, with:
import nstd/auto       ## Converters and other automatic or non-explicit behavior
