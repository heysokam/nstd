#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________


# System aliases
import ./nstd/types     ; export types
import ./nstd/alias     ; export alias
# Extensions
import ./nstd/address   ; export address
import ./nstd/binary    ; export binary
import ./nstd/compile   ; export compile
import ./nstd/convert   ; export convert
import ./nstd/defines   ; export defines
import ./nstd/dirs      ; export dirs
import ./nstd/format    ; export format
import ./nstd/git       ; export git
import ./nstd/iter      ; export iter
import ./nstd/logger    ; export logger
import ./nstd/macros    ; export macros
import ./nstd/node      ; export node
import ./nstd/opts      ; export opts
import ./nstd/paths     ; export paths
import ./nstd/size      ; export size
import ./nstd/time      ; export time
import ./nstd/typetools ; export typetools


# WRN
# ./nstd/auto is not exported automatically. 
# Converters and automatic behavior are dangerous.
# But sometimes they are helpful, so for those cases the functionality is there.
# It should be explicitely imported where its used, with:
import nstd/auto  ## Converters (automatic or non-explicit behavior)

