in.init ()

(* Fenêtre principale *)
let window = GWindow.window 
  ~width:300 
  ~resizable:true
  ~title:"CavatOCR" ()
(*Emplacement ou il faut mettre l'emplacement a boutons & l'image*)
let vbox = GPack.vbox 
  ~spacing:10
  ~border_width:10
  ~packing:window#add ()
(*Les differentes fonctions que l'on utilise*)
let open_message () = print_endline "Ici il faut rajouter du vrai code pour choisir et enregistrer un fichier"
let apply_message () = print_endline "Placer la transformation image ici"
let modify_message () = print_endline "Ici c'est pour apres quand on aura un retour text"
let save_message () = print_endline "Enregistre la sortie de texte"

(*Test de l'emplacement pour voir ou ca va*)
let bbox = GPack.button_box `HORIZONTAL(*Ca sepack al'horisontale*)
  ~layout:`SPREAD
  ~packing:(vbox#pack ~expand:false) ()(*Prends tout l'espace dispo*)

let openfile = 
  let button = GButton.button 
    ~stock:`HELP
    ~packing:bbox#add () in(*concatene a l'horisontal dans bbox*)
  button#connect#clicked ~callback:open_message;
  button

let apply = 
  let button = GButton.button 
    ~stock:`HELP
    ~packing:bbox#add () in
  button#connect#clicked ~callback:help_apply;
  button

let modiffy = 
  let button = GButton.button 
    ~stock:`HELP
    ~packing:bbox#add () in
  button#connect#clicked ~callback:modify_message;
  button

let sauvegarder = 
  let button = GButton.button 
    ~stock:`HELP
    ~packing:bbox#add () in
  button#connect#clicked ~callback:save_message;
  button


