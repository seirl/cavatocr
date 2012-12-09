(** Shortcut for defining an image *)
type img_t = bool array array

(** Different types of block *)
type id_block =
  | Page
  | Line
  | Word
  | Character
  | Image (* Generic *)

(** A block of text *)
type 'a t_block =
{
    id:id_block; (* Tells which type of block it is *)
    l:int; (* Left edge *)
    r:int; (* Right edge *)
    t:int; (* Top edge *)
    b:int; (* Bottom edge *)

    mutable content: 'a
}

let content_of_block ({id=_;l=_;r=_;t=_;b=_;content=i}) = i

let sample_block t = {id=t;l=0;r=0;t=0;b=0;content=Matrix.make 0 0 false}

let block_of_img ?l:(l=0) ?t:(t=0) img =
  let (w, h) = Matrix.get_dims img in
    {id=Image;l=0;r=w;b=h;t=0;content=img}

let bool_sum = Array.fold_left (fun n b -> if b then n+1 else n) 0

let get_line i img =
  let (_,h) = Matrix.get_dims img in
      Array.map (fun col -> col.(h - 1 - i)) img

(** Get the vertical histogram of an image *)
let vertical_histt img =
  let (w, h) = Matrix.get_dims img in
  let hist = Array.make h 0 in
    begin
      for y = 0 to h - 1 do
        hist.(y) <- bool_sum (get_line y img);
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

let add_row img row = Array.append img ([| row |])

(** Cut an image into lines of text *)
let get_lines (block: img_t t_block)=
  begin
    let h = (block.b) - (block.t) in
    let lines = ref [] in
    let current_line = ref (sample_block Line) in
    let threshold = 3 in
    let in_line = ref false in
    let vhist = vertical_histt (block.content) in

    for i=0 to h-1 do
      if not !in_line
      then
        if vhist.(i) <= threshold
        (* we are between two lines *)
        then ()
        else
        (* new line *)
          begin
          in_line := true;
          current_line :=
             { id=Line;
               l=block.l; r=block.r;
               t=block.t + i; b=block.t + i;
               content=[| get_line i (block.content) |]
             }
          end

      else if vhist.(i) <= threshold
      (* end of a line *)
      then
        begin
          in_line := false;
          lines := !current_line :: !lines;
          current_line := sample_block Line
        end
      else
      (* new row in a line *)
        match !current_line with
          | ({id=id;l=l;r=r;t=t;b=b;content=line}) ->
              current_line :=
              {id=id;l=l;r=r;t=t;b=b+1;
               content=add_row line (get_line i (block.content))
              }
    done;
    List.iter (fun block -> block.content <- rot_170 block.content) !lines;
    { id=Page;
      l=block.l;r=block.r;
      b=block.b;t=block.t;
      content=Array.of_list (!lines)}
  end


(** Cut a line of text into characters *)
let get_chars (block: img_t t_block) =
  begin
    let w = (block.r) - (block.l) in
    let chars = ref [] in
    let current_char = ref (sample_block Character) in
    let threshold = 1 in
    let in_char = ref false in
    let hhist = horizontal_hist (block.content) in

    for i=0 to w-1 do
      if not !in_char
      then
        if hhist.(i) <= threshold
        (* we are between two characters *)
        then ()
        else
        (* new character *)
          begin
          in_char := true;
          current_char :=
             { id=Character;
               l=block.l + i; r=block.l + i;
               t=block.t; b=block.t;
               content=[| block.content.(i) |]
             }
          end

      else if hhist.(i) <= threshold
      (* end of a character *)
      then
        begin
          in_char := false;
          chars := !current_char :: !chars;
          current_char := sample_block Character
        end
      else
      (* new pixel column in a character *)
        match !current_char with
          | ({id=id;l=l;r=r;t=t;b=b;content=c}) ->
              current_char :=
              { id=id;l=l;r=r+1;t=t;b=b;
                content=add_row c (block.content.(i))
              }
    done;
    { id=Page;
      l=block.l;r=block.r;
      b=block.b;t=block.t;
      content=Array.of_list (List.rev !chars)
    }
  end

let white_vhist line =
  let hist = Array.make (Array.length line - 1) 0 in
    begin
      for i=0 to Array.length line - 2 do
        hist.(i) <- line.(i+1).l - line.(i).r
      done;
      Array.sort (-) hist;
      hist
    end

let max_vars dists nbmaxs =
  let fst (a,b) = a in
  let list_maxs = Array.make nbmaxs (0,-1) in
    for i = 1 to (Array.length dists) - 1 do
      let var = dists.(i) - dists.(i-1) in
      let j = ref (nbmaxs - 1) in
        while !j >= 0 && (fst (list_maxs.(!j))) >= var do
          j := !j - 1
        done;
        if !j <> -1 then
          begin
            for k = 0 to !j - 1 do
              list_maxs.(k) <- list_maxs.(k+1)
            done;
            list_maxs.(!j) <- (var, dists.(i-1))
          end
    done;
    list_maxs

let moy_consecutive list_maxs =
  let list_moy = Array.make (Array.length list_maxs) 0 in
    for i = 0 to Array.length list_moy - 1 do
      let var, low = list_maxs.(i) in
      list_moy.(i) <- low + (var / 2)
    done;
    list_moy


let get_words av_sep ({id=_;l=l;r=r;t=t;b=b;content=line}) =
  let current_word = ref [| |] in
  let words = ref [| |] in
    for i=0 to Array.length line - 1 do
      current_word := Array.append !current_word ([| line.(i) |]);
      if i = Array.length line - 1 || (line.(i+1).l - line.(i).r) >= av_sep
      then (* end of word *)
        begin
          words := Array.append !words [| !current_word |];
          current_word := [| |]
        end
    done;
    {id=Line;
     l=l;r=r;
     t=t;b=b;
     content=(!words)
    }


(** Extract all text lines in an image (return a list of blocks) *)
let extract_lines img = get_lines (block_of_img img)

(** Extract all characters of an image (return a list of lines, each being a
  * block containing a list of blocks characters *)
let extract_chars img =
  let img = get_lines (block_of_img img) in
  {id=img.id;
   l=img.l;r=img.r;
   t=img.t;b=img.b;
   content=Array.map get_chars (img.content)
  }


(** Take a line (array of characters) and return a list of words (list of list
  * of characters) *)
let words_of_line line =
  if line.content = [||] then
    {id=Line;
     l=0;r=0;
     t=0;b=0;
     content=([||])
    } else
  let vhist = white_vhist (line.content) in
  match moy_consecutive (max_vars vhist 2) with
    | [| _;words_threshold |] ->
        get_words words_threshold line
    | _ -> failwith "words_of_line: moy_consecutive didn't return 2 elements"

let extract img =
  let w, h = Matrix.get_dims img in
  let chars = extract_chars img in
 {id=Page;
  l=0;r=w;
  t=0;b=h;
  content=Array.map (words_of_line) (chars.content)
 }

let expand_full_block block =
  let lines = block.content in
  let words = Array.map content_of_block lines in
  let chars = Array.map (Array.map (Array.map content_of_block)) words in
    chars



(* Well, an extracted image is "bool array array array array array array" :
 * An array of columns
 * each being an array of lines
 * each being an array of words
 * each being an array of characters
 * each being a matrix of bool
 *)
