#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/macros
import std/strutils
import std/strformat
import std/os

# Tools for Interoperability with C code.

#____________________________________________________________________________
macro compileGlob *(dir, pattern, flags :static[string]) :untyped=
  ## Globs all files in `dir` that end with `pattern`
  ## and emits a compile pragma for each of them
  ## {.compile:"dir/file.ext", "--someflags" }
  if not dir.dirExists: echo &"WARNING:\n  Tried to search for files at folder  {dir}  but it doesn't exist."
  result = newStmtList()
  for x in dir.walkDir():
    if not x.path.endsWith(pattern): continue
    result.add nnkPragma.newTree(
      nnkCall.newTree(
      newIdentNode("compile"), 
      newLit(x.path), 
      newLit(flags))
    )
  if result.repr == "": echo &"WARNING:\n  compileGlob hasn't found any files for:  {dir}  with pattern:  {pattern}."
#____________________________________________________________________________

