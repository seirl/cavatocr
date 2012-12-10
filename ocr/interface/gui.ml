let image = ref (Image.create_surface 0 0)
let mat = ref (Matrix.make 0 0 false)


let window =
  ignore (GMain.init ());
  let window = GWindow.window
                 ~title:"CavatOCR"
                 ~position:`CENTER
                 ~resizable:true
                 ~width:400 ~height:600 () in
    ignore (window#connect#destroy GMain.quit);
    window

(* Where everything happends*)
let vbox = GPack.vbox
             ~spacing:2
             ~border_width:2
             ~packing:window#add ()

(* The toolbar*)
let toolbar = GButton.toolbar
                ~orientation:`HORIZONTAL
                ~style:`ICONS
                (*~layout:`SPREAD*) (*This fonction bug*)
                ~packing:(vbox#pack ~expand:false) ()

(*Box of the pic*)
let view = GPack.vbox ~packing:vbox#add ()

(* {{{ function zone *)
(*Check if we can add the pic & add*)
let may_view btn () =
  match btn#filename with
      Some n ->
        image := Image.load n;
        ignore (GMisc.image
                  ~file: n
                  ~packing:view#add())
    | None -> ()

(* Function to Test. *)
let print_test () =
  Printf.printf "Test.\n"

(* To avoid unfortunate closing*)
let confirm _ =
  let dlg = GWindow.message_dialog
              ~message:"<b><big>Do you really want to leave ?</big>\n\n\
                        Warning :\nall unsaved modifications will be lost </b>\n"
              ~parent:window
              ~destroy_with_parent:true
              ~use_markup:true
              ~message_type:`QUESTION
              ~position:`CENTER_ON_PARENT
              ~buttons:GWindow.Buttons.yes_no () in
  let res = dlg#run () = `NO in
    dlg#destroy ();
    res
(* }}} *)

(* {{{ toolbar zone *)

(*Stock of picture for the toolbar*)
let item1 = GButton.tool_item ~packing:toolbar#insert ()
let item2 = GButton.tool_item ~packing:toolbar#insert ()
let item3 = GButton.tool_item ~packing:toolbar#insert ()
let item4 = GButton.tool_item ~packing:toolbar#insert ()

(**)
let buttonopen =
  let button = GFile.chooser_button
                 ~action:`OPEN
                 ~packing:item1#add ()
  in ignore (button#connect#selection_changed (may_view button));
     button

(** Item2 : The edit button, useless for the moment, the place to radio button*)
let button = GButton.button
               ~packing: item2#add()
               ~label: "Edit"

(** Item3 : Where help is more or less given when clicked*)
let help_button =
  let dlg = GWindow.message_dialog
              ~message:"<b><big>Need help ?</big>\n\n\
type CavatOCR --help</b>"
              ~parent:window
                        ~destroy_with_parent:true
                        ~use_markup:true
                        ~message_type:`QUESTION
                        ~position:`CENTER_ON_PARENT
                        ~buttons:GWindow.Buttons.ok ()
  in
  let button = GButton.button ~stock:`HELP ~packing:item3#add () in
    ignore (GMisc.image ~stock:`HELP ~packing:button#set_image ());
    ignore (button#connect#clicked
              (fun () -> ignore (dlg#run ()); dlg#misc#hide ()));
    button

(** Item4 : The button where our names appear*)
let about_button =
  let dlg = GWindow.about_dialog
    ~authors:["Pinkie PIE :\nHervot Paul, Pietri Antoine,
              Kostas Thomas, Lefebvre Stephane"]
    ~copyright:"2012"
    ~license:"Public License."
    ~version:"1.00"
    ~website:"http://cavatocr.serialk.fr/"
    ~website_label:"Our website"
    ~position:`CENTER_ON_PARENT
    ~parent:window
    ~destroy_with_parent:true () in
  let button = GButton.button ~stock:`ABOUT ~packing:item4#add () in
    ignore (GMisc.image ~stock:`ABOUT ~packing:button#set_image ());
    ignore (button#connect#clicked
              (fun () -> ignore (dlg#run ()); dlg#misc#hide ()));
    button


(* }}} *)

(* {{{ button zone*)
(* The button bar*)
let bbox = GPack.button_box `HORIZONTAL (*Box of bottom interface*)
  ~layout:`EDGE
  ~border_width:2
  ~packing:(vbox#pack ~expand:false) ()

let show img =
  let display = Image.display_for_matrix img in
    begin
      Image.show_matrix img display;
      Image.wait_key ();
    end

(** The preprocessing button*)
let preprocess () =
  mat := Filters.filter (!image)
(*
let preprocessing =
  let button = GButton.button
                 ~label: "Preprocessing"
                 ~packing: bbox#add()
  in ignore (button#connect#clicked ~callback:(preprocess));
     button
 *)

(** The extraction button*)
let text_window =
  ignore (GMain.init ());
  let wnd = GWindow.window ~width:150 ~height:100 () in
  ignore (wnd#connect#destroy GMain.quit);
  wnd

let packing =
  let hbox = GPack.hbox
    ~spacing:5
    ~border_width:5
    ~packing:text_window#add () in
  hbox#pack ~expand:false

let extr () =
  let get_filter file = Filters.filter (file) in

  let get_rotate file =
    let filtered = get_filter file in
      Rotate.rotate filtered (Rotate.get_skew_angle filtered)
  in
  let recognize_char mat = (* FIXME seirl *)
    let corr = Resize.local_moy mat 5 5 in
    let mlp = Mlp.from_file "nn.bin" in
      mlp#process corr;
      mlp#find_char

  in

  let recognize_word word =
    let rec_array = Array.map recognize_char word in
    let rec_array = Array.map (Char.escaped) rec_array in
      Array.fold_left (^) "" rec_array
  in

  let recognize_line line =
    let rec_line = Array.map recognize_word line in
      String.concat " " (Array.to_list rec_line)
  in

  let recognize_page page =
    let rec_page = Array.map recognize_line page in
      String.concat "\n" (Array.to_list rec_page)
  in
  let get_extract file =
    let rotated = get_rotate file in
    let extracted = Blocks.extract rotated in
    let expanded = Blocks.expand_full_block extracted in
      recognize_page expanded
  in
    List.iter (fun text -> ignore (GMisc.label ~packing ~text ()))
      [get_extract (!image)];
    text_window#show ();
    GMain.main ()
  
let extract =
  let button = GButton.button
                 ~label: "Extract"
                 ~packing: bbox#add()
  in ignore (button#connect#clicked ~callback:(extr));
     button

(* The button to quit*)
let buttonquit =
  let btn = GButton.button
              ~stock:`QUIT
              ~packing:bbox#add () in
    ignore (btn#connect#clicked ~callback:GMain.quit);
    btn

(* }}} *)

let main () =
  ignore (window#event#connect#delete confirm);
  window#show ();
  GMain.main ()
