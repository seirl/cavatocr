let chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" ^
            "!\"#$%&'()*+,-./:;<=>?@[]^_`{|}~\\"

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
    dst

let gen_chars () =
  let fonts = get_fonts_paths () in
  let font_array = Array.make (Array.length fonts) [||] in
    for i = 0 to (Array.length fonts) - 1 do
      let font = Sdlttf.open_font ("fonts/" ^ fonts.(i)) 26 in
        font_array.(i) <- Array.init (String.length chars)
            (fun n -> (chars.[n], make_image font (Char.escaped chars.[n])))
    done;
    font_array

let train_mlp chr surface mlp =
  Filters.image2grey surface;
  let mat = Filters.binarize surface in
  let corresp = Resize.local_moy mat 5 5 in
  let img = Image.surface_of_moy corresp 5 5 in
    Image.show img (Image.display_for_image img);
    Image.wait_key ();
    mlp#learn corresp chr

let train () =
  let mlp = 
    if Sys.file_exists "nn.bin" then
      Mlp.from_file "nn.bin"
    else
      begin
        let arr = Array.init (String.length chars) (fun n -> chars.[n]) in
        let mlp = new Mlp.t [|25; 69; 42; (String.length chars)|] arr in
          mlp
      end
  in
  let fonts = gen_chars () in
    for k = 0 to 50 do
      Printf.printf "iteration #%3d" k;
      for i = 0 to (Array.length fonts) - 1 do
        for j = 0 to (Array.length fonts.(i)) - 1 do
          let (chr, surface) = fonts.(i).(j) in
            train_mlp chr surface mlp
        done;
      done
    done;
    mlp#save "nn.bin"

