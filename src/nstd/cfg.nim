#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
const Prefix  *{.strdefine.}=  "「nstd」"
  ## @descr Prefix to add to formatted messages
const LogName *{.strdefine.}=   Prefix & "Logger"
  ## @descr Formatted string used by the loggers by default when omitted
const LogFlushAll *{.booldefine.}=  off
  ## @descr When on, the loggers will flush all messages by default when omitted.
