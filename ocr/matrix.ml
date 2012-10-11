let nbrows = Array.length
let nbcols x = Array.length x.(0)
let make = Array.make_matrix
let coords (c,r) h = (c, h - r - 1)
let pos (x,y) h = (h - y - 1, x)
let print_matrix mat =
    for r = 0 to Matrix.nbrows mat - 1 do
        for c = 0 to Matrix.nbcols mat - 1 do
            Printf.printf "%B " mat.(r).(c);
        done;
        Printf.printf "\n";
    done

