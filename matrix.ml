let nbrows = Array.length
let nbcols x = Array.length x.(0)
let make = Array.make_matrix
let coords (c,r) h = (c, h - r - 1)
let pos (x,y) h = (h - y - 1, x)
