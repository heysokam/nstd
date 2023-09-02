#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
const Prefix  *{.strdefine.}=  "「nstd」"
  ## Prefix to add to formatted messages
const LogName *{.strdefine.}=   Prefix & "Logger"
  ## Formatted string used by the loggers by default when omitted
const LogFlushAll *{.booldefine.}=  off
  ## When on, the loggers will flush all messages by default when omitted.
