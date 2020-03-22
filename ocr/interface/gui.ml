let window =
  ignore (GMain.init ());
  let window = GWindow.window
                 ~title:"CavatOCR"
                 ~position:`CENTER
                 ~resizable:true
                 ~width:400 ~height:600 () in
    ignore (window#connect#destroy GMain.quit);
    window

(*Test with pointers*)
let name_of_image = ref ""
let name_of_text = ref ""
 
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
let view = GBin.scrolled_window
 ~packing:vbox#add ()

(* {{{ function zone *)
(*GUIgui*)
(* Image*)
let view_image = GMisc.image
  ~file:!name_of_image
  ~packing:view#add_with_viewport ()

let open_image my_image () =
  print_string (my_image#filename);
  name_of_image := my_image#filename;
  view_image#set_file !name_of_image

(* Text*)
(* let view_text = new Gui_class_text.editor *)
  (* ~packing:scrolled_window_text#add_with_viewport () *)

let insert_text (buffer : GText.buffer) =
   buffer#set_text (!name_of_text)


(* Ca marche bien parce que c'est pique
 *(* Button temporaire *)
  let button_open = GButton.button () in
   Gui_button.make_icon
    "icons/open.png" "Open" button_open#add ();
   table1#attach
    ~left:0
    ~top:0 (button_open#coerce);
    button_open#connect#clicked ~callback:(display_dialog_box);

    let button_pretreat = GButton.button () in
    Gui_button.make_icon
      "icons/pretreatment.png" "Preprocessing" button_pretreat#add ();
    table1#attach
      ~left:1
      ~top:0 (button_pretreat#coerce);
    (*button_pretreat#connect#clicked ~callback:(actualize view_image);*)

    let button_recogni = GButton.button () in
      Gui_button.make_icon
        "icons/recognition.xpm" "Extraction" button_recogni#add ();
      table1#attach
        ~left:2
        ~top:0 (button_recogni#coerce);
      button_recogni#connect#clicked ~callback:(recognition);

      let button_save = GButton.button () in
        Gui_button.make_icon
          "icons/save.png" "Save Text" button_save#add ();
        table1#attach ~left:3 ~top:0 (button_save#coerce);
        button_save#connect#clicked ~callback:(view_text#save_as);

      let button_help = GButton.button () in
      Gui_button.make_icon
             "icons/help.png" "Help & About" button_help#add ();
      table1#attach ~left:4 ~top:0 (button_help#coerce);
      button_help#connect#clicked ~callback:(Gui_help_menu.help_contents);

       let buffer = view_text#text#buffer in
          insert_text buffer;
      GtkSpell.attach (*~lang:"fr iso8859-1"*) view_text#text;
       window#add_accel_group accel_group;
        window#show ();
    GMain.main ()
          

 *
 *
 *
 * *)

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
  (*Trucs bien: GText GFile GAction*)
(* ce serait bien que la fonction te renvoit une matrice de booléens, que tu garde
 *dans un coin, pour l'afficher tu peux appeler Image.surface_of_matrix dessus*)

let save (text : GText.view) file =
  let och = open_out file in
  output_string och (text#buffer#get_text ());
  close_out och


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
    ignore (btn#connect#clicked ~callback:GMain.quit);
    btn

(* }}} *)

let main () =
  ignore (window#event#connect#delete confirm);
  window#show ();
  GMain.main ()
