let chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    ^ "!\"#$%&'()*+,-./:;<=>?@[]^_`{|}~\\"
let chars_separated = "0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r"
    ^ "s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Z"
    ^ "! \" # $ % & ' ( ) * + , - . / : ; < = > ? @ [ ] ^ _ ` { | } ~ \\"

type fontstyle =
  | Normal
  | Bold
  | Italic
  | BoldItalic

let get_fonts_paths () =
  if Sys.is_directory "./fonts" then
    Sys.readdir "./fonts"
  else
    [||]

let make_image font str =
  let src = Sdlttf.render_text font (Sdlttf.BLENDED(Sdlvideo.black)) str in
  let (w,h) = Image.get_dims src in
  let dst = Image.create_surface w h in
    for x = 0 to w - 1 do
      for y = 0 to h - 1 do
        Sdlvideo.put_pixel_color dst x y (255,255,255);
      done
    done;
    Sdlvideo.blit_surface src dst ();
    Filters.filter dst

let gen_chars () =
  let fonts = get_fonts_paths () in
  let font_array = Array.make (Array.length fonts) [||] in
    for i = 0 to (Array.length fonts) - 1 do
      let font = Sdlttf.open_font ("fonts/" ^ fonts.(i)) 20 in
      let arr = Blocks.expand_full_block
                  (Blocks.extract (make_image font chars_separated)) in
        font_array.(i) <- Array.concat (Array.to_list arr.(0))
    done;
    font_array

let train_network chr mat network =
    network#learn mat chr

let train n =
  let network = new Network.network in
    if Sys.file_exists "network.bin" then
      network#from_file "network.bin";
    let fonts = gen_chars () in
      for k = 0 to n do
        Printf.printf "iteration #%3d…\n" k;
        for i = 0 to (Array.length fonts) - 1 do
          for j = 0 to (Array.length fonts.(i)) - 1 do
              let (chr, surface) = chars.[j], fonts.(i).(j) in
                (*Image.show_matrix surface (Image.display_for_matrix surface);
                Image.wait_key ();*)
                train_network chr surface network
          done
        done
      done;
      network#to_file "network.bin"

