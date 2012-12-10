Image.sdl_init ()

let show img =
  let display = Image.display_for_matrix img in
    begin
      Image.show_matrix img display;
      Image.wait_key ();
    end

let main () = Gui.main ()

let get_filter file = Filters.filter (Image.load file)
let filter file = show (get_filter file)

let get_rotate file =
  let filtered = get_filter file in
    Rotate.rotate filtered (Rotate.get_skew_angle filtered)

let rotate file =
  let filtered = get_filter file in
  let angle = Rotate.get_skew_angle filtered in
    show (Rotate.rotate filtered angle);
    show (Rotate.trace_histogram filtered angle)

let recognize_char mat = 
  let network = new Network.network in
    network#from_file "network.bin";
    network#read_char mat

let recognize_word word =
  let rec_array = Array.map recognize_char word in
  let rec_array = Array.map (Char.escaped) rec_array in
    Array.fold_left (^) "" rec_array

let recognize_line line =
  let rec_line = Array.map recognize_word line in
    String.concat " " (Array.to_list rec_line)

let recognize_page page =
  let rec_page = Array.map recognize_line page in
    String.concat "\n" (Array.to_list rec_page)

let get_extract file =
  let rotated = get_rotate file in
  let extracted = Blocks.extract rotated in
  let expanded = Blocks.expand_full_block extracted in
    recognize_page expanded
let extract file = print_endline (get_extract file)

let train n =
  Image.sdl_init ();
  Ttf.train n

let minimum a b c =
  min a (min b c)
 
(* {{{ Correction *)
let levenshtein_distance s t =
  let m = String.length s
  and n = String.length t in
  (* for all i and j, d.(i).(j) will hold the Levenshtein distance between
     the first i characters of s and the first j characters of t *)
  let d = Array.make_matrix (m+1) (n+1) 0 in
  for i = 0 to m do
    d.(i).(0) <- i  (* the distance of any first string to an empty second string *)
  done;
  for j = 0 to n do
    d.(0).(j) <- j  (* the distance of any second string to an empty first string *)
  done;
  for j = 1 to n do
    for i = 1 to m do
      if s.[i-1] = t.[j-1] then
        d.(i).(j) <- d.(i-1).(j-1)  (* no operation required *)
      else
        d.(i).(j) <- minimum
                       (d.(i-1).(j) + 1)   (* a deletion *)
                       (d.(i).(j-1) + 1)   (* an insertion *)
                       (d.(i-1).(j-1) + 1) (* a substitution *)
    done;
  done;
  d.(m).(n)

let read filename =
  let lines = ref [] in
  let chan = open_in filename in
    try
      while true; do
        lines := input_line chan :: !lines
      done; [||]
    with End_of_file ->
      close_in chan;
      Array.of_list (List.rev !lines)

let split s = Array.of_list (Str.split (Str.regexp " ") s)
let dico = read "dico_fr.txt"
let guess file =
  let recognized = split (get_extract file) in
  let rec_size = Array.length recognized - 1 in
  let dico_size = Array.length (dico)  - 1 in
    for i=0 to rec_size do
      let closest = ref "" in (* closest word found *)
      let l_closest = ref 1000 in (* tiniest levenshtein distance found *)
      let j = ref 0 in
        while !j < dico_size do
          let l = levenshtein_distance (recognized.(i)) (dico.(!j)) in
            if l = 0 then
              begin
                closest := dico.(!j);
                j := dico_size
              end
            else if l < !l_closest then
              begin
                closest := dico.(!j);
                l_closest := l
              end
            else ();
            j := !j + 1
        done;
        recognized.(i) <- !closest
    done;
    print_endline (String.concat " " (Array.to_list recognized))
(* }}} *)

let specs = 
  [
    ("--gui", Arg.Unit(main), "launch the user interface");
    ("--filter", Arg.String(filter), "Show the image after cleaning");
    ("--rotate", Arg.String(rotate), "Show the image cleaned and reorientated");
    ("--extract", Arg.String(extract), "Print the recognized text");
    ("--guess", Arg.String(guess), "Print the recognized and corrected text");
    ("--train", Arg.Int(train), "Train the neural network")
  ]

let usage =
  Printf.sprintf
    "Usage: %s --gui | --filter | --rotate | --extract | --train"
    (Sys.argv.(0))

let _ =
    Arg.parse specs print_string usage
