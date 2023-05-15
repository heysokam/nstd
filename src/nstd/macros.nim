#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# std dependencies
import std/macros
import std/typetraits

macro baseType *(t :typedesc) :untyped=
  ## Gets the base type of t, skipping distinct and aliases
  let impl = t.getImpl()
  if impl[^1].typeKind == ntyTypeDesc:
    newCall(bindSym"baseType", impl[^1])
  else:
    impl[^1]

macro upperType *(t :typedesc) :untyped=  t.getImpl()[^1]
  ## Gets the typedesc from which t is being aliased.

func upperType *[T](val :T) :typedesc=  val.distinctBase.type
  ## Gets the type from which the typedesc T of val is being aliased.

macro getLitName *(e :untyped) :untyped= newLit($e)
  ## Generates a newLit string from the given input.
  ## e.g. Convert GLEnum, which is a const distinct uint32,
  ##      to its string name representation at compile time.
  ##      This example is not possible without this macro,
  ##      because `$` and similars dispatch the uint or its value, and not the variable name.

# TODO: TableEntry generator
# template genEntry (entry :GLEnum) :untyped=  entry : getLitName(entry)

