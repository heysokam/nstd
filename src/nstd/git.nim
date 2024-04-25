#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/osproc import execCmdEx
from std/sequtils import filterIt
# @deps nstd
import ./strings


#_______________________________________
# @section Ergonomic Commands
#_____________________________
proc git *(args :varargs[string, `$`]) :string {.discardable.}= osproc.execCmdEx("git " & args.join(" ")).output
  ## @descr Executes git, passing it the given list of {@arg args}
proc gh  *(args :varargs[string, `$`]) :tuple[output:string, code:int] {.discardable}=
  ## @descr Executes GitHub's CLI, passing it the given list of {@arg args}
  (result.output, result.code) = osproc.execCmdEx("gh " & args.join(" "))


#_______________________________________
# @section Changes Management
#_____________________________
proc getPreviousTag *(fallback :string) :string=
  ## @descr
  ##  Finds the last version that was released on the repository, based on the git tags of this repo
  ##  Uses {@arg fallback} as the fallback tag when no tag could be found
  let describe = osproc.execCmdEx("git describe --tags --abbrev=0")
  result = if describe.exitCode == 0: describe.output.splitLines()[0] else: fallback
#___________________
proc getChangesSince *(start :string) :string=
  ## @descr Executes `git` and returns the Header+Body of every commit from {@arg start} until HEAD of the repository
  ## @note Only adds information from the root branch, ignoring any of their children (ie: merged branches, and similar)
  var lines :seq[string]
  for line in git("log", "--pretty=format:%B", fmt"{start}..HEAD", "--first-parent").splitLines.filterIt(it != ""):
    if line[3] != ':' : lines[^1].add line  # chg: Some change
    else              : lines.add line
  result = lines.join("\n")


#____________________________________________________
# TODO: Patchnotes Format Management
#_______________________________________
#   ## Changed
#   chg: First change that happend for x
#   chg: Other change was also applied
#   chg: Some other things changed too
#
#   ## Removed
#   rmv: Some thing got removed
#
#   ## Buildsystem
#   bld: asdf
#
#   ## Documentation
#   doc: 11234
#
#____________________________________________________
# Legend
#_______________________________________
# # User-Facing changes
# new : New features  
# chg : Change in existing functionality  
# dep : Soon-to-be removed feature  
# rmv : Removed feature  
# fix : Bug fixes.  
# sec : Security, in case of vulnerabilities.  
# ... : Part of the feature listed above it  
#
# # Development changes
# bld : Changes to the buildsystem. New and fixes
# doc : Changes to the documentation. New and fixes
# org : Project organization / structuring. Not related to code (use fmt for code organization)
# fmt : Formatting, styling, Refactor of code. Naming, organizing, reflow, etc. No behavior changes
# tst : Changes to tests code. No production code changed
#
#____________________________________________________

