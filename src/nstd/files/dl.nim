#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
# nstd dependencies
import ../types

#____________________________________
# Downloading
proc dl *(link :str) :void=
  try:             exec &"wget {link}"; echo &":: Downloaded file from link: {link}"
  except OSError:  quit &"::ERR Failed to download file from {link}"
proc dl *(link, o :str) :void=
  try:             exec &"wget -O {o} {link}"; echo &":: Downloaded file from link {link}  as {o}"
  except OSError:  quit &"::ERR Failed to download file from {link} as {o}"
proc dl *(link :str, c:bool) :void=  # Download without clobbing when c=false
  try:
    let nc = if c: "" else: "-nc"
    exec &"wget {nc} {link}"
    echo &":: Downloaded file from link: {link}"
  except OSError:  quit &"::ERR Failed to download file from {link}"


