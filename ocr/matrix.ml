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

let print_int_matrix mat =
  for r = 0 to (nbrows mat) - 1 do
    for c = 0 to (nbcols mat) - 1 do
      Printf.printf "%2d " mat.(r).(c);
    done;
    Printf.printf "\n";
  done

let copy m =
  let l = Array.length m in
    if l = 0 then m else
      let result = Array.make l m.(0) in
        for i = 0 to l - 1 do
           result.(i) <- Array.copy m.(i)
        done;
        result
