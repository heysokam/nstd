#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

template submodulesUpdate *()=  exec "git submodule foreach git checkout master; git submodule foreach git merge origin/master"
