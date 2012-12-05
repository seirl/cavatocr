(** This module can detect blocks of text and extract all characters from an
    image.
    In this module, the term "image" refer to a bool array array (the binary
    matrix representation of an image) *)

let bool_sum = Array.fold_left (fun n b -> if b then n+1 else n) 0

let get_line i h = Array.map (fun col -> col.(h - 1 - i))

(** Get the vertical histogram of an image *)
let vertical_histt img =
  let (w, h) = Matrix.get_dims img in
  let hist = Array.make h 0 in
    begin
      for y = 0 to h - 1 do
        hist.(y) <- bool_sum (get_line y h img);
      done;
      hist
    end

(** Get the horizontal histogram of an image *)
let horizontal_hist img = Array.map bool_sum img

let rot_170 img =
  begin
    let (w, h) = Matrix.get_dims img in
    let rotated = Matrix.make h w true in
      for x = 0 to w - 1 do
        for y = 0 to h - 1 do
          rotated.(y).(w - 1 - x) <- img.(x).(y)
        done;
      done;
      rotated
  end


(** Get the list of lines present in the image *)
let lines_of_image (img:bool array array) =
  let hist = vertical_histt img in
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
    List.rev_map
      (fun mat -> rot_170 mat)
      (merge_per_line 0 [])

let words_of_line (line:bool array array) =
  let hist = horizontal_hist line in
  let w = Array.length hist in
  let threshold = 0 in
  let whitespace_threshold = 8 in
  let rec merge_per_col (x:int) (whitespace:int) (accu:bool array array list) =
    (* End of image, return final merge *)
    if x >= w then accu

    else let col = line.(x) in
      (* Empty column *)
      if hist.(x) <= threshold
      then match accu with
        | [] -> merge_per_col (x + 1) (0) (accu)
        | block_char :: accu_t ->
            if whitespace <= whitespace_threshold then
              merge_per_col (x + 1) (whitespace + 1)
                ((Array.append block_char ([| col |])) :: accu_t)
            else
              merge_per_col (x + 1) (whitespace + 1) accu

      (* First column and non-empty or new non-empty column after many empty *)
      else if accu = [] || (hist.(x - 1) <= threshold
           && whitespace >= whitespace_threshold)
      then merge_per_col (x + 1) 0 ([| col |] :: accu)

      (* Another non-empty column *)
      else match accu with
        | [] -> failwith
                  "merge_line: not first non-empty line but accu is empty"
        | block_char :: accu_t ->
            merge_per_col (x + 1) (0)
              ((Array.append block_char ([| col |])) :: accu_t)
  in
    List.rev (merge_per_col 0 0 [])

(** Get the list of characters present in a line *)
let chars_of_line (line:bool array array) =
  let hist = horizontal_hist line in
  let w = Array.length hist in
  let threshold = 0 in
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
    List.rev (merge_per_col 0 [])

(** Get all characters of an image *)
let words_of_image img = List.map (words_of_line) (lines_of_image img)
let chars_of_image img = List.map (List.map chars_of_line) (words_of_image img)
