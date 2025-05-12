#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/os
from std/strutils import startsWith
from std/strformat import `&`
import std/parseopt
import std/tables


#_________________________________________________
# @section Types for CLI options
#_____________________________
type ArgList    = seq[string]
type OptEntries = OrderedTable[string,seq[string]]
type OptList    = object
  short *:OptEntries
  long  *:OptEntries
#_____________________________
type CLI * = object
  args  *:ArgList
  opts  *:OptList

#_________________________________________________
# @section Types Management aliases and forward exports
#_____________________________
func contains *(list :OptEntries; opt :string) :bool=  list.hasKey(opt)
iterator items *(list :OptEntries) :string=
  for key in list.keys: yield key

#_________________________________________________
# @section General CLI parse
#_____________________________
proc getCLI *() :CLI=
  var parser = commandLineParams().initOptParser()
  for kind, key, val in parser.getOpt():
    case kind
    of cmdArgument                : result.args.add( key )
    of cmdLongOption              :
      if key in result.opts.long  : result.opts.long[key].add val
      else                        : result.opts.long[key] = @[val]
    of cmdShortOption             :
      if key in result.opts.short : result.opts.short[key].add val
      else                        : result.opts.short[key] = @[val]
    of cmdEnd: assert true, "Reached a cmdEnd kind. Should never happen."

#_________________________________________________
# @section Get specific Elements
#_____________________________
proc getArgs *() :seq[string]=  getCLI().args
#___________________
proc getArg  *(id :SomeInteger) :string=  getCLI().args[id]
#___________________
proc getOpt  *(
    cli : opts.CLI;
    opt : char|string;
  ) :bool=
  ## @descr Returns true if the given short option was passed in CLI
  # Treat the input as a short option
  when opt is char:
    return $opt in cli.opts.short
  elif opt is string:
    # Treat the input as a long option
    if opt.startsWith("--"):
      return $opt[2..^1] in cli.opts.long
    # Treat the input as a list of options in a single word, or as a short option starting with `-`
    else:
      var list :string= opt
      if list.startsWith("-"): list = list[1..^1]  # Remove the first character from the input
      for ch in list:
        if &"{ch}" notin cli.opts.short: return false  # Exit early when one of the characters of the `opt` input was not passed in cli
      return true                                      # All options of the `opt` input were passed in cli, so return true
#___________________
proc has *(
    cli : opts.CLI;
    opt : char|string;
  ) :bool {.inline.}= cli.getOpt(opt)
#___________________
proc getOpt *(opt :char|string) :bool= opts.getCLI().getOpt(opt)
#___________________
proc getLong *(
    cli : CLI;
    opt : string;
  ) :string=
  for key,values in cli.opts.long.pairs:
    if key == opt: return cli.opts.long[key][^1]
#___________________
iterator getLongIter *(cli :CLI; opt :string) :string=
  for long,values in cli.opts.long.pairs:
    if long != opt: continue
    for entry in values: yield entry

