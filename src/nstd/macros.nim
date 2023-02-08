#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
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

