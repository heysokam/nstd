#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________

#__________________________________________________
# Tool: Logger
#____________________
# Levels
type LogLevel * = enum NoLog, Info, Warn, Error, Trace, Max
converter toInt *(x :LogLevel) :int=  x.ord


