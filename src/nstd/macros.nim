#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/macros
import std/typetraits


#___________________
macro baseType *(t :typedesc) :untyped=
  ## Gets the base type of t, skipping distinct and aliases
  let impl = t.getImpl()
  if impl[^1].typeKind == ntyTypeDesc:
    newCall(bindSym"baseType", impl[^1])
  else:
    impl[^1]

#___________________
macro upperType *(t :typedesc) :untyped=  t.getImpl()[^1]
  ## Gets the typedesc from which t is being aliased.
func upperType *[T](val :T) :typedesc=  val.distinctBase.type
  ## Gets the type from which the typedesc T of val is being aliased.

#___________________
macro getLitName *(e :untyped) :untyped= newLit($e)
  ## Generates a newLit string from the given input.
  ## e.g. Convert GLEnum, which is a const distinct uint32,
  ##      to its string name representation at compile time.
  ##      This example is not possible without this macro,
  ##      because `$` and similars dispatch the uint or its value, and not the variable name.

#_____________________________
macro name (v :typed) :untyped=
  ## Returns the name of a dot expression or a symbol as a string literal.
  if   v.kind == nnkSym:      result = newLit v.strVal
  elif v.kind == nnkDotExpr:  result = newLit v[1].repr
  else:                       error("expected to work on DotExpr or Sym", v)

#_____________________________
proc getStr *(n :NimNode) :string=
  ## Returns the correct string value of a string node.
  result = n.strVal()
  if n.kind == nnkSym:
    result = n.getImpl()[^1].strVal
#_____________________________
proc isEmpty  *(n :NimNode) :bool=  n.kind == nnkEmpty
proc isList   *(n :NimNode) :bool=  n.kind == nnkStmtList
proc isAssign *(n :NimNode) :bool=  n.kind == nnkAsgn
proc isReturn *(n :NimNode) :bool=  n.kind == nnkReturnStmt
proc isResult *(n :NimNode) :bool=  n.len != 0 and n[0].kind == nnkSym and n[0].strVal == "result"

#_____________________________
iterator childrenRev *(n :NimNode) :NimNode {.inline.}=
  ## Iterates over the children of the NimNode `n` in reverse order.
  for id in 0..<n.len: yield n[^(id+1)]

#_____________________________
proc report *(n :NimNode; id :SomeInteger) :void=
  ## Reports the treeRepr of the given node, with a marker to identify it.
  when not defined(release) and not defined(danger):
    echo &"---{id}---\n",n.treeRepr

