let nbcols = Array.length
let nbrows x = Array.length x.(0)
let get_dims m = (nbcols m, nbrows m)
let make = Array.make_matrix

let print_matrix mat =
  for r = 0 to (nbrows mat) - 1 do
    for c = 0 to (nbcols mat) - 1 do
      Printf.printf "%d " (Tools.int_of_bool mat.(r).(c));
    done;
    Printf.printf "\n";
  done
