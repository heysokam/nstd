#:______________________________________________________________________
#  Reid Engine : Copyright (C) Ivan Mar (sOkam!) : GNU GPLv3 or higher :
#:______________________________________________________________________
# Module dependencies
import ./types

#____________________
type 
  Node *[T]= ref object of RootObj
    fwd   *:seq[Node[T]]
    data  *:T
#____________________
proc next *[T](n :Node) :Node=  n.fwd
proc children *[T]= next[T]
#____________________


#____________________
type Node2 *[T] = ref object of Node[T]
  bwd *:Node
#____________________
proc prev   *[T](n :Node[T]) :Node[T]=  n.bwd
proc parent *[T]=  prev[T]
#____________________


#____________________
proc hasChild  *[T](node :Node[T]) :bool=  node.fwd.len != 0
  ## Checks if the given node has children nodes
proc hasData   *[T](node :Node[T]) :bool=  node.data != T()
  ## Checks if the given node has data
  ## TODO: Double check that  data != T()  behaves as expected
#______________________________
proc isLeaf    *[T](node :Node[T]) :bool=  not node.hasChild and node.hasData
  ## Checks if the given node is a leaf node,
  ## by checking that it has no children but it has data
proc isPartial *[T](node :Node[T]) :bool=  node.hasChild and node.hasData
  ## Checks if the given node is a partial split node,
  ## by checking that it has children but it also has data
proc isEmpty   *[T](node :Node[T]) :bool=  not node.hasChild and not node.hasData
  ## Checks if the given node is an empty node,
  ## by checking that it has not children and it has no data
proc isBranch  *[T](node :Node[T]) :bool=  node.hasChild and not node.hasData
  ## Checks if the given node is a branch node,
  ## by checking that it has children and but it has no data
#______________________________
proc countItems *[T](node :Node[T]) :u64=
  ## Count the number of data items that the node contains
  if node.hasChild:
    for child in node.children:
      result += child.data.len
  elif node.hasData:
    result += node.data.len
  else: result = 0
