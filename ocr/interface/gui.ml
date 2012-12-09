let window =
  GMain.init ();
  let wnd = GWindow.window
    ~title:"CavatOCR"
    ~position:`CENTER 
    ~resizable:true
    ~width:400 ~height:600 () in
  wnd#connect#destroy GMain.quit;
  wnd

(*delete main page *)

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


let vbox = GPack.vbox  (* Box where the image is put*)
  ~spacing:2
  ~border_width:2
  ~packing:window#add ()


let toolbar = GButton.toolbar   (*box of toolbar of top  inteface*)  
  ~orientation:`HORIZONTAL  
  ~style:`ICONS 
  (*~layout:`SPREAD*) (*This fonction bug*)
  ~packing:(vbox#pack ~expand:false) ()  


let view = GPack.vbox ~packing:vbox#add () (*Box of the pic *)

let bbox = GPack.button_box `HORIZONTAL (*Box of bottom interface*)
  ~layout:`EDGE 
  ~border_width:2
  ~packing:(vbox#pack ~expand:false) () 

(*Check if we can add the pic & add*)
let may_view btn () =
match btn#filename with
Some n ->
ignore (GMisc.image
~file: n
~packing:view#add())
| None -> ()

(*Stock of picture for the toolbar*)
let item = GButton.tool_item ~packing:toolbar#insert () 
let item2 = GButton.tool_item ~packing:toolbar#insert ()
let item3 = GButton.tool_item ~packing:toolbar#insert ()
let item4 = GButton.tool_item ~packing:toolbar#insert ()

let buttonopen =
let btn = GFile.chooser_button
~action:`OPEN
~packing:item#add ()
          in btn#connect#selection_changed (may_view btn);
btn

(* the preprocessing function, add the link to the real action*)

let fonction1 = GButton.button
~packing: bbox#add()
~label: "preprocessing"

(*The extraction function*)
let fonction2 = GButton.button
~packing: bbox#add()
~label: "extract"
(* fonction1#connect#clicked ~callback: fonction args*)


let btn = GButton.button
~packing: item2#add()
~label: "Edit"
(*add a menu with radio button of the filtres*)


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
  let btn = GButton.button ~stock:`HELP ~packing:item3#add () in
   GMisc.image ~stock:`HELP ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn


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
  let btn = GButton.button ~stock:`ABOUT ~packing:item4#add () in
   GMisc.image ~stock:`ABOUT ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

let buttonquit = 
  let btn = GButton.button
    ~stock:`QUIT
    ~packing:bbox#add () in
  btn#connect#clicked ~callback:GMain.quit;
  btn

let _ =
  window#event#connect#delete confirm;
  window#show ();
  GMain.main ()


(*ocaml -w s -I +lablgtk1 lablgtk.cma ocr.ml*)
