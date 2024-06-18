#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
include ./base


#____________________________________________________
test nstd.Prefix&" String Case Formatting: First Character":
  check "abc1_3AV_asd".firstUpper() == "Abc1_3AV_asd"
  check "Abc1_3AV_asd".firstLower() == "abc1_3AV_asd"

#____________________________________________________
test nstd.Prefix&" String Case Formatting: SCREAM_CASE":
  check "MAKE_API_VERSION".change(SCREAM_CASE, SCREAM_CASE) ==  "MAKE_API_VERSION"
  check "MAKE_API_VERSION".change(SCREAM_CASE, PascalCase)  ==  "MakeApiVersion"
  check "MAKE_API_VERSION".change(SCREAM_CASE, camelCase)   ==  "makeApiVersion"
  check "MAKE_API_VERSION".change(SCREAM_CASE, snake_case)  ==  "make_api_version"

#____________________________________________________
test nstd.Prefix&" String Case Formatting: PascalCase":
  check "MakeApiVersion".change(PascalCase, SCREAM_CASE) ==  "MAKE_API_VERSION"
  check "MakeApiVersion".change(PascalCase, PascalCase)  ==  "MakeApiVersion"
  check "MakeApiVersion".change(PascalCase, camelCase)   ==  "makeApiVersion"
  check "MakeApiVersion".change(PascalCase, snake_case)  ==  "make_api_version"

#____________________________________________________
test nstd.Prefix&" String Case Formatting: camelCase":
  check "makeApiVersion".change(camelCase, SCREAM_CASE) ==  "MAKE_API_VERSION"
  check "makeApiVersion".change(camelCase, PascalCase)  ==  "MakeApiVersion"
  check "makeApiVersion".change(camelCase, camelCase)   ==  "makeApiVersion"
  check "makeApiVersion".change(camelCase, snake_case)  ==  "make_api_version"

#____________________________________________________
test nstd.Prefix&" String Case Formatting: snake_case":
  check "make_api_version".change(snake_case, SCREAM_CASE) ==  "MAKE_API_VERSION"
  check "make_api_version".change(snake_case, PascalCase)  ==  "MakeApiVersion"
  check "make_api_version".change(snake_case, camelCase)   ==  "makeApiVersion"
  check "make_api_version".change(snake_case, snake_case)  ==  "make_api_version"

