(* In this file, the term "image" refer to a bool array array (the binary matrix
 * representation of an image
 * *)

let bool_sum = Array.fold_left (fun n b -> if b then n+1 else n) 0

let get_line i h = Array.map (fun col -> col.(h - 1 - i))

(* Get the vertical histogram of an image *)
let hist_vert img =
  let (w, h) = Matrix.get_dims img in
  let hist = Array.make h 0 in
    begin
      for y = 0 to h - 1 do
        hist.(y) <- bool_sum (get_line y h img);
      done;
      hist
    end

(* Get the horizontal histogram of an image *)
let hist_hor img = Array.map bool_sum img

(* Get the list of lines present in the image *)
let get_lines (img:bool array array) =
  let hist = hist_vert img in
  let h = Array.length hist in
  let threshold = 2 in
  let rec merge_per_line (y:int) (accu:bool array array list) =
    (* End of image, return final merge *)
    if y >= h then accu

    else let line = get_line y h img in
      (* Empty line, discard and evaluate next *)
      if hist.(y) <= threshold then merge_per_line (y + 1) accu

      (* First line and non-empty or new non-empty line after some empty *)
      else if y = 0 || hist.(y - 1) <= threshold
      then merge_per_line (y + 1) ([| line |] :: accu)

      (* Another non-empty line *)
      else match accu with
        | [] -> failwith
                  "merge_line: not first non-empty line but accu is empty"
        | block_lines :: accu_t ->
            merge_per_line (y + 1)
              ((Array.append block_lines ([| line |])) :: accu_t)
  in
    List.map
      (fun mat -> Rotate.rotate mat (Rotate.pi /. (-2.)))
      (merge_per_line 0 [])

let get_chars (line:bool array array) =
  let hist = hist_hor line in
  let w = Array.length hist in
  let threshold = 2 in
  let rec merge_per_col (x:int) (accu:bool array array list) =
    (* End of image, return final merge *)
    if x >= w then accu

    else let col = line.(x) in
      (* Empty column, discard and evaluate next *)
      if hist.(x) <= threshold then merge_per_col (x + 1) accu

      (* First column and non-empty or new non-empty column after some empty *)
      else if x = 0 || hist.(x - 1) <= threshold
      then merge_per_col (x + 1) ([| col |] :: accu)

      (* Another non-empty column *)
      else match accu with
        | [] -> failwith
                  "merge_line: not first non-empty line but accu is empty"
        | block_char :: accu_t ->
            merge_per_col (x + 1)
              ((Array.append block_char ([| col |])) :: accu_t)
  in
    merge_per_col 0 []
