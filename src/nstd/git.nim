#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________


template submodulesUpdate *()=  exec "git submodule foreach git checkout master; git submodule foreach git merge origin/master"
