#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/strformat
# nstd dependencies
import ../types

#TODO: remove bash dependency
#____________________________________
# Downloading
proc dl *(link :str) :void=
  ## Dowloads the file from the given link into the current working directory.
  try:             exec &"wget {link}"; echo &":: Downloaded file from link: {link}"
  except OSError:  quit &"::ERR Failed to download file from {link}"

proc dl *(link, outfile :str) :void=
  ## Dowloads the file from the given link into the current working directory.
  ## Resulting file will be renamed as `outfile`.
  try:             exec &"wget -O {outfile} {link}"; echo &":: Downloaded file from link {link}  as {outfile}"
  except OSError:  quit &"::ERR Failed to download file from {link} as {outfile}"

proc dl *(link :str, c:bool) :void=  # Download without clobbing when c=false
  try:
    let nc = if c: "" else: "-nc"
    exec &"wget {nc} {link}"
    echo &":: Downloaded file from link: {link}"
  except OSError:  quit &"::ERR Failed to download file from {link}"


