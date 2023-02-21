#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________


#________________________________________
proc append *(file, data :string)=
  var f :File
  let ok = f.open(file, fmAppend)
  if not ok:
    echo "Opening ",file," failed"
    return
  f.write(file)
