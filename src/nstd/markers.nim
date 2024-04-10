#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# Code markers for different tasks  |
#:__________________________________|
# std dependencies
import std/[tables, strutils]
import std/macros as stdMacros
# n*std dependencies
import ./macros


#______________________________________________________________
# Unreachable Marker
#_______________________________________
type Unreachable * = object of Defect  ## Defect raised when a block of code that is not expected to be reached is actually executed
template unreachable *(msg :string= "")=
  ## Marks a block of code as unreachable. Raises an exception when actually entering the block.
  ## Useful to debug for difficult to track edge cases and work in progress sections of the code.
  const inst = instantiationInfo()
  const info = "$#($#,$#): " % [inst.fileName, $inst.line, $inst.column]
  raise newException(Unreachable, info & msg)


#_________________________________________________________________
# Todo Marker
# written by beef331 : https://github.com/beef331/nimtrest/wiki/Code-snippets#todo
#______________________________________________________________
var todos {.compileTime.} :Table[string, seq[string]]
  ## Internal state of the todo module (compile-time only)

#_______________________________________
template todo *(msg :static string= "")=
  ## Mark block as an unlabelled todo with the given message, and add it to the internal list.
  ## Usage:  `todo "this is a todo"`
  static:
    const label   = getModule()
    const info    = instantiationInfo()
    discard todos.hasKeyOrPut(label, newSeq[string]())
    todos[label].add "$#($#,$#): $#" % [info.fileName, $info.line, $info.column, when msg != "": msg else: getName()]
  {.warning: "Todo: " & msg.}

#_______________________________________
template todo *(label,msg :static string)=
  ## Adds a todo with the given label+message to the internal list.
  ## Usage:  `todo("label"): "this is a todo"`
  static:
    const info  = instantiationInfo()
    discard todos.hasKeyOrPut(label, newSeq[string]())
    todos[label].add "$#($#,$#): $#" % [info.fileName, $info.line, $info.column, msg]
  {.warning: "Todo: " & msg.}


#_______________________________________
proc report *() :string {.compileTime.}=
  ## Returns a string with all todos stored in the current list
  for entry, msgs in todos:
    result.add entry
    result.add "\n"
    for msg in msgs:
      result.add "  "
      result.add msg
      result.add "\n"

