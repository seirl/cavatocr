(*Totalement pompe d'internet*)
module Aux =
  struct
    let load (text : GText.view) file =
      let ich = open_in file in
      let len = in_channel_length ich in
      let buf = Buffer.create len in
      Buffer.add_channel buf ich len;
      close_in ich;
      text#buffer#set_text (Buffer.contents buf)

    let save (text : GText.view) file =
      let och = open_out file in
      output_string och (text#buffer#get_text ());
      close_out och
  end

let _ = GMain.init ()

(* GtkWindow - Fenêtre principale. *)
let window =
  let wnd = GWindow.window 
    ~height:300 
    ~resizable:false(*Rq perso: Ils ont tendance a faire du resizable false*)
    ~position:`CENTER
    ~title:"GWindow Demo" () in
  wnd#connect#destroy GMain.quit;
  wnd

(* GtkMessageDialog - Court message à l'attention de l'utilisateur. *)
let confirm _ =
  let dlg = GWindow.message_dialog
    ~message:"<b><big>Voulez-vous vraiment quitter ?</big>\n\n\
      Attention :\nToutes les modifications seront perdues.</b>\n"
    ~parent:window
    ~destroy_with_parent:true
    ~use_markup:true
    ~message_type:`QUESTION
    ~position:`CENTER_ON_PARENT
    ~buttons:GWindow.Buttons.yes_no () in
  let res = dlg#run () = `NO in
  dlg#destroy ();
  res

let vbox = GPack.vbox 
  ~spacing:5
  ~border_width:5
  ~packing:window#add ()

let text =
  let scroll = GBin.scrolled_window
    ~hpolicy:`ALWAYS
    ~vpolicy:`ALWAYS
    ~shadow_type:`ETCHED_IN
    ~packing:vbox#add () in
  let txt = GText.view ~packing:scroll#add () in
  txt#misc#modify_font_by_name "Monospace 10";
  txt

let bbox = GPack.button_box `HORIZONTAL
  ~spacing:5
  ~layout:`SPREAD
  ~packing:(vbox#pack ~expand:false) ()

(* GtkFileChooserDialog - Boîte de dialogue d'ouverture et d'enregistrement. *)
let action_button stock event action =
  let dlg = GWindow.file_chooser_dialog
    ~action:`OPEN
    ~parent:window
    ~position:`CENTER_ON_PARENT
    ~destroy_with_parent:true () in
  dlg#add_button_stock `CANCEL `CANCEL;
  dlg#add_select_button_stock stock event;
  let btn = GButton.button ~stock ~packing:bbox#add () in
  GMisc.image ~stock ~packing:btn#set_image ();
  btn#connect#clicked (fun () ->
    if dlg#run () = `OPEN then Gaux.may action dlg#filename;
    dlg#misc#hide ());
  btn

let open_button = action_button `OPEN `OPEN (Aux.load text)
let save_button = action_button `SAVE `SAVE (Aux.save text)

(* GtkColorSelectionDialog - Sélection de couleur. *)
let color_picker =
  let dlg = GWindow.color_selection_dialog
    ~parent:window
    ~destroy_with_parent:true
    ~position:`CENTER_ON_PARENT () in
  dlg#ok_button#connect#clicked (fun () -> 
    text#misc#modify_base [`NORMAL, `COLOR dlg#colorsel#color]);
  let btn = GButton.button ~label:"Arrière-plan" ~packing:bbox#add () in
  GMisc.image ~stock:`COLOR_PICKER ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

(* GtkFontSelectionDialog - Sélection de fonte. *)
let font_button =
  let dlg = GWindow.font_selection_dialog
    ~parent:window
    ~destroy_with_parent:true
    ~position:`CENTER_ON_PARENT () in
  dlg#ok_button#connect#clicked (fun () -> 
    text#misc#modify_font_by_name dlg#selection#font_name);
  let btn = GButton.button ~stock:`SELECT_FONT ~packing:bbox#add () in
  GMisc.image ~stock:`SELECT_FONT ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

(* GtkAboutDialog - Boîte de dialogue "À propos..." *)
let about_button =
  let dlg = GWindow.about_dialog
    ~authors:["Cacophrene (<cacophrene AT gmail DOT com>)"]
    ~copyright:"Copyright © 2009-2010 Cacophrene"
    ~license:"GNU General Public License v3"
    ~version:"1.0"
    ~website:"http://blog.developpez.com/ocamlblog/"
    ~website_label:"OCamlBlog"
    ~position:`CENTER_ON_PARENT
    ~parent:window
    ~destroy_with_parent:true () in
  let btn = GButton.button ~stock:`ABOUT ~packing:bbox#add () in
  GMisc.image ~stock:`ABOUT ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

let _ =
  window#event#connect#delete confirm;
  window#show ();
  GMain.main ()

