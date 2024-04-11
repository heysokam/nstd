#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/macros as m import add
from std/os import lastPathPart
from std/algorithm import reversed
# @deps ndk
from ./strings import endsWith

#_____________________________
macro importAll *(dir :static[string]; importOnly :static[openArray[string]]= []) :untyped=
  ## @descr Imports all `.nim` files inside the given {@arg dir} folder
  # Exit early if dir does not exist,
  if not os.dirExists(dir): return
  # Generate the import list AST
  result = m.newStmtList()
  let filter = importOnly.len > 0
  # └─ Create the list of imported files
  var list :seq[string]
  for file in os.walkDir(dir):
    if not file.path.endsWith(".nim"): continue
    if filter and file.path.lastPathPart notin importOnly: continue
    list.add file.path
  # └─ Generate the import AST nodes
  for file in list.reversed:
    result.add( m.newTree(
      m.nnkImportStmt,
      m.newLit(file)
      )) # << result.add( m.newTree( ... ) )
#_____________________________
macro importAllRec *(dir :static[string]; importOnly :static[openArray[string]]= []) :untyped=
  ## @descr Imports all `.nim` files inside the given {@arg dir} folder and all folders contained inside it
  # Exit early if dir does not exist,
  if not os.dirExists(dir): return
  # Generate the import list AST
  result = m.newStmtList()
  let filter = importOnly.len > 0
  # └─ Create the list of imported files
  var list :seq[string]
  for file in os.walkDirRec(dir):
    if not file.endsWith(".nim"): continue
    if filter and file.lastPathPart notin importOnly: continue
    list.add file
  # └─ Generate the import AST nodes
  for file in list.reversed:
    result.add( m.newTree(
      m.nnkImportStmt,
      m.newLit(file)
      )) # << result.add( m.newTree( ... ) )

