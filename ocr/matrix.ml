let nbrows = Array.length
let nbcols x = Array.length x.(0)
let get_dims m = (nbrows m, nbcols m)
let make = Array.make_matrix
let int_of_bool (b: bool) = if b then 1 else 0;;

let print_matrix mat =
    for r = 0 to (nbrows mat) - 1 do
        for c = 0 to (nbcols mat) - 1 do
            Printf.printf "%d " (int_of_bool mat.(r).(c));
        done;
        Printf.printf "\n";
    done

