#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# n*std dependencies
import ../cfg
import ./types
import ./helpers

#___________________
export cfg.Prefix

#___________________
let   DefPath       * = getDefaultFile()
const DefName       * = cfg.LogName
const DefThreshold  * = Log.All
const DefFlushLvl   * = when cfg.LogFlushAll: Log.All else: Log.Fatal
const DefVerbose    * = when defined(release) or defined(danger): false elif defined(debug): true else: true
