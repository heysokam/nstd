#______________________________________________________________________________
# TODO
#_____________________________
# @section Path Formatting
#___________________
# func wrapped *(
#     path   : Path;
#     prefix : static string = "";
#     strip  : static string = "";
#   ) :string=
#   ## @descr
#   ##  Returns the {@arg path} as a string where each word is wrapped between "", and separated with {@link DirSep}
#   ##  Adds the {@arg prefix} at the start of {@arg path}   (default: no prefix)
#   ##  Removes any word that matches {@arg strip}           (default: strip nothing)
#   # @note This function used to be clear and clean T_T
#   let words = path.string.split(DirSep)
#   if prefix != "": result.add prefix & $DirSep
#   var skip :bool
#   for id,val in words.pairs:
#     if val == strip:
#       if id == 0: skip = true
#       continue
#     if id != 0:
#       if skip : skip = false
#       else    : result.add DirSep
#     result.add val.string.wrapped
# #___________________
# func wrapped *(
#     list   : seq[Path];
#     prefix : static string = "";
#     strip  : static string = "";
#   ) :seq[string]=
#   ## @descr Returns the {@arg list} as a list of wrapped {@link Path}s.
#   ## @see {@link wrapped[Path,string,string]}
#   for file in list: result.add file.wrapped(prefix, strip)

