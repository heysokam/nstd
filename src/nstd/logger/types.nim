#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________

#__________________________________________________
# Tool: Logger
#____________________
# Levels
type LogLevel * = enum nolog, info, warn, error, trace, maxloglvl
converter toInt *(x :LogLevel) :int= x.ord


