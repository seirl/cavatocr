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
          in button#connect#selection_changed (may_view button);
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
    ~buttons:GWindow.Buttons.ok     ()
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

(** The preprocessing button*)
let preprocessing =
  let button = GButton.button
    ~label: "Preprocessing"
    ~packing: bbox#add()
    in ignore(button#connect#clicked ~callback:(print_test));
button

(** The extraction button*)
let extract =
  let button = GButton.button
    ~label: "Extract"
    ~packing: bbox#add()
    in ignore (button#connect#clicked ~callback:(print_test));
button

(* The button to quit*)
let buttonquit =
  let btn = GButton.button
    ~stock:`QUIT
    ~packing:bbox#add () in
  btn#connect#clicked ~callback:GMain.quit;
  btn

(* }}} *)

let _ =
  window#event#connect#delete confirm;
  window#show ();
  GMain.main ()
