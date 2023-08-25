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
import nstd/dirs       ## Tools for dir management
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

# Not exported by default
# Import manually to use them
import nstd/auto       ## Converters and other automatic or non-explicit behavior
```
```md
# Compile-time Switches
-d:nstdPrefix:"STRING"     : (default: "「nstd」")
-d:nstdLogFormat:"STRING"  : (default: ???) #TODO
-d:nstdLogFlushAll:on/off  : (default: off)
```

**License**:   MIT | Copyright © `Ivan Mar (sOkam!)`

