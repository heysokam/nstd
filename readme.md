# Nim non-standard stdlib extensions

Collection of general purpose tools to extend Nim's std/ library.
It doesn't try to be standard. Just useful.

```nim
import nstd            ## Connector to all modules (except ntsd/auto)

import nstd/types      ## System type aliases
import nstd/procs      ## System proc aliases
import nstd/refs       ## System ref extensions
import nstd/dirs       ## Tools for dir management
import nstd/convert    ## Type conversion tools
import nstd/iter       ## Extra Iterators
import nstd/macros     ## Extra Macros
import nstd/C          ## C interoperability tools
import nstd/logger     ## Logging interface for functionality from other tools
import nstd/format     ## Tools for formatting of text on console and logs
import nstd/time       ## Ergonomic helpers for managing time
import nstd/node       ## Node type and functionality

# Not exported by default
# Import manually to use them
import nstd/auto       ## Converters and other automatic or non-explicit behavior
```

**License**:
Copyright © `Ivan Mar (sOkam!)` | MIT License (MIT)
