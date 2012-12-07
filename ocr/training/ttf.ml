let load_font = Sdlttf.open_font

type fontstyle =
  | Normal
  | Bold
  | Italic
  | BoldItalic

let get_fonts_paths =
  if Sys.is_directory "./fonts" then
    Sys.readdir "./fonts"

let make_image font str = Sdlttf.render_text font SOLID(Sdlvideo.black) str

let train_mlp chr surface mlp =
  let mat = Image.binarize (Image.color2grey surface) in
  let corresp = Resize.local_moy mat in
    mlp#learn corresp chr

