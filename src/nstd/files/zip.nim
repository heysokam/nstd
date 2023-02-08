#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/os
import std/strutils
import std/strformat
# nstd dependencies
import ../types

# TODO: when nimvm: else:
# Currently uses only nimvm

proc zip_p (s,d :str) :void= # Zips files literally (absolute or relative, whatever is passed) (internal use only)
  try:             exec &"zip -vr {d} {s}"; echo &":: Created zip file {d} from the contents of {s}"
  except OSError:  quit &"::ERR Failed to create zip file {d} from {s}"
proc zipAbs *(s,d :str) :void=  zip_p s, d
proc zip *(s :seq[str],d:str) :void=  #alias zip="zip -v ", but for Sequences of strs (file lists)
  var tseq=s
  echo &":: Splitting list of files {s}"
  for it in mitems(tseq): it = it.relativePath(getCurrentDir()); echo &": {it}"
  let t = tseq.join(" ")
  zip_p t, d
proc zip *(s,d :str) :void=
  let t = s.split(" "); zip t, d  #alias zip="zip -v "
proc zipd_p(s:str,d:str)= # Removes files from target zip file (internal use only)
  try:             exec &"zip -vd {d} {s}"; echo &":: Deleted {s} file from the contents of {d}"
  except OSError:  quit &"::ERR Failed to delete file {s} from {d}"
proc zipd *(s,d :str) :void=  zipd_p s, d  #alias zipd="zip -vd"
# Unzipping
proc unzip*(f,d:str; ow:bool)=
  let o = if ow: "-o" else: ""
  try:             exec &"unzip {o} -d {d} {f}"; echo &":: Extracted file {f} to folder {d}"
  except OSError:  quit &"::ERR Failed to extract file {f} to folder {d}"
proc unzip*(f,d :str) :void=  unzip(f,d,true) # Assume overwrite when omitted

# TODO:
##[
def Pk3(list, trg, rel=None):
  if isPath(trg): trg = str(trg)
  if isPath(rel): rel = str(rel)
  from os.path import splitext
  z = splitext(trg)[0]+".zip" 
  p = splitext(trg)[0]+".pk3" 
  Zip(list, z, rel)
  mv(z,p)
#.....................................
def ZipDir(src,trg,rel=None):
  # TODO: Exclude option, like Pk3CreateAll
  if isPath(src): src = str(src)
  if isPath(trg): trg = str(trg)
  if isPath(rel): rel = str(rel)
  from os.path import relpath, join; from os import walk
  from zipfile import ZipFile, ZIP_DEFLATED
  if not rel: rel = src
  z = ZipFile(trg, 'w', ZIP_DEFLATED)
  for root, dirs, files in walk(src):
    for file in files:
      frel = relpath(root, rel)
      z.write(join(root, file), arcname=join(frel, file))
  z.close()

def Pk3Dir(src, trg, rel=None):
  if isPath(src): src = str(src)
  if isPath(trg): trg = str(trg)
  if isPath(rel): rel = str(rel)
  from os.path import basename, splitext, dirname, join
  z = splitext(basename(trg))[0]+".zip"
  p = splitext(basename(trg))[0]+".pk3"
  ZipDir(src, z, rel)
  mv(z, join(dirname(trg), p))
#.....................................
def Pk3CreateAll(src, trg, prefix=None, exclude=None):
  #TODO: Incremental packing. How?
  if isPath(src): src = str(src)
  if isPath(trg): trg = str(trg)
  from os.path import join, basename, isdir 
  if prefix is None: prefix = "y.custom."
  dirs = [d for d in glob(src, "*") if d.is_dir() or isdir(d)]
  if exclude: dirs = [d for d in dirs if d.name not in exclude]
  for it in dirs:  # For every folder in src
    if isEmpty(it): continue # Skip empty folder
    pk3 = join(trg, f"{prefix}{basename(it)}.pk3")
    Pk3Dir(it, pk3)
]##

