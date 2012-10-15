let hist_of_img img =
  Array.map (Array.fold_left (fun n b -> if b then n+1 else n) 0) img

let merge_lines (hist:int array) (img:bool array array) =
  let rec merge_per_line (line:int) (accu:bool array array list) =
    (* End of image, return final merge *)
    if line >= Array.length hist then accu

    (* Empty line, discard and evaluate next *)
    else if hist.(line) <= 2 then merge_per_line (line + 1) accu

    (* First line and non-empty or new non-empty line after some empty *)
    else if line = 0 || hist.(line - 1) <= 2 then [| img.(line) |] :: accu

    (* Another non-empty line *)
    else match accu with
      | [] -> failwith "merge_line: not first non-empty line but accu is empty"
      | block_lines :: accu_t -> Array.append block_lines ([| img.(line) |]) :: accu_t
  in
    merge_per_line 0 []

let get_lines img =
  let hist = hist_of_img img in
    merge_lines hist img

(*
let main () =
  let sdl_init () =
    begin
      Sdl.init [`EVERYTHING];
      Sdlevent.enable_events Sdlevent.all_events_mask;
    end
  and sdl_load () =
    Sdlloader.load_image Sys.argv.(1)
  in

    sdl_init;
    let img = sdl_load () in
*)
