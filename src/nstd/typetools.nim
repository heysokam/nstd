#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________


#__________________
proc isType *(list :tuple; t :typedesc) :bool=
  ## @descr Checks that the items of the tuple are all `t` type.
  result = true
  for it in list.fields:
    when it isnot t: return false

#__________________
template isObject *(T :typedesc) :bool=  T is object or T is ref object
  ## @descr Checks that the given type is an object.

#___________________
func fieldList *(T :typedesc) :seq[string]=
  ## @descr Returns a sequence that contains the names of all fields in {@arg obj}
  assert T.isObject, "nstd.typetools.fieldList(obj) can only be used on object types"
  let tmp = default(T)
  for field,val in tmp.fieldPairs:
    result.add(
      if field == "typ" : "type"
      else              : field
      ) # << result.add( ... )

#__________________
proc `new` *[T](x :T) :ref T=
  ## @descr
  ##  Creates a new ref T from the given value
  ##  Alias for:
  ##    val   = new(T)
  ##    val[] = thing
  new result
  result[] = x

#___________________
proc `@` *[T1, T2](val :T1; typ :typedesc[T2]) :T2=  cast[T2](val)
  ## @descr Casts the contents of {@arg val} to the given {@arg typ}
  ## @reason Syntax ergonomics. Same as MinC casting



