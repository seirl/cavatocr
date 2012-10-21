(** Get the dimensions of a SDL surface: a couple (width, height) *)
let get_dims img =
(
      (Sdlvideo.surface_info img).Sdlvideo.w,
      (Sdlvideo.surface_info img).Sdlvideo.h
)

(** Initialize SDL *)
let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end

(** Load an image as a SDL rgb surface *)
let load name = Sdlloader.load_image name

let color_of_bool = function
    | true -> Sdlvideo.black
    | false -> Sdlvideo.white

(** Initialize a SDL surface *)
let create_surface w h = Sdlvideo.create_RGB_surface
    [ `SWSURFACE ] ~w:w ~h:h ~bpp:32
    ~rmask:Int32.zero ~gmask:Int32.zero ~bmask:Int32.zero ~amask:Int32.zero 

(** Get a display surface *)
let display w h = Sdlvideo.set_video_mode w h [`DOUBLEBUF]

(** Same with the size of a given surface *)
let display_for_image img =
  let w, h = get_dims img in
    display w h

(** Display a SDL surface on the dst display *)
let show img dst =
  let d = Sdlvideo.display_format img in
    Sdlvideo.blit_surface d dst ();
    Sdlvideo.flip dst

(** Wait for a key to be pressed before continue *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
    match e with
        Sdlevent.KEYDOWN _ -> ()
      | _ -> wait_key ()

let bool_of_pixel (color,_,_) = color = 255
