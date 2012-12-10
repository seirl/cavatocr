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

let specs = 
  [
    ("--gui", Arg.Unit(main), "launch the user interface");
    ("--filter", Arg.String(filter), "Show the image after cleaning");
    ("--rotate", Arg.String(rotate), "Show the image cleaned and reorientated");
    ("--extract", Arg.String(extract), "Print the recognized text");
    ("--train", Arg.Int(train), "Train the neural network")
  ]

let usage =
  Printf.sprintf
    "Usage: %s --gui | --filter | --rotate | --extract | --train"
    (Sys.argv.(0))

let _ =
    Arg.parse specs print_string usage
