![nstd](./res/gh_banner.png)
Collection of general purpose tools to extend Nim's std/ library.  
It doesn't try to be standard. Just useful.  

```nim
import nstd            ## Connector to all modules (except ntsd/auto)

import nstd/types      ## System type aliases
import nstd/typetools  ## General Type tools and helpers
import nstd/address    ## Address-related helpers, for easier C interop
import nstd/alias      ## System proc aliases
import nstd/binary     ## Read data from string bytebuffer binary information (like treeform/binny)
import nstd/compile    ## Buildsystem helpers for compiling C code from inside Nim
import nstd/convert    ## Type conversion tools
import nstd/defines    ## General-purpose defines, for ergonomics
import nstd/modules    ## Nim Modules management (import, include) tools
import nstd/dirs       ## Tools for dir management
import nstd/files      ## Tools for managing the PathFile type
import nstd/format     ## Tools for formatting of text on console and logs
import nstd/git        ## Git-related tools
import nstd/iter       ## Extra Iterators
import nstd/logger     ## Logging tools  (heavily refactored version of std/logging)
import nstd/markers    ## Templates for marking code paths in different ways (todo, unreachable, etc)
import nstd/macros     ## Extra Macros
import nstd/node       ## Node type and functionality
import nstd/opts       ## CLI option tools
import nstd/paths      ## os.paths missing procs (borrow from string) and extensions
import nstd/size       ## sizeof() extensions
import nstd/time       ## Ergonomic helpers for managing time

# Not exported by default. They require dependencies other than nim's stdlib
import nstd/dl         ## Ergonomic helpers for downloading files, in similar style to `nstd/shell`
import nstd/zip        ## Ergonomic helpers for zipping files and folders, in similar style to `nstd/shell`
```
```md
# Compile-time Switches
-d:nstd.Prefix:"STRING"     : (default: "「nstd」")
-d:nstd.LogName:"STRING"    : (default: nstd.Prefix & "Logger" )
-d:nstd.LogFormat:"STRING"  : (default: ???) #TODO
-d:nstd.LogFlushAll:on/off  : (default: off)
```

**License**:   MIT | Copyright © `Ivan Mar (sOkam!)`

