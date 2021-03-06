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
    Sdlttf.init ();
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end

(** Load an image as a matrix of three color: (int,int,int) array array *)
let load = Sdlloader.load_image

let color_of_bool = function
  | true -> Sdlvideo.black
  | false -> Sdlvideo.white

(** Initialize a SDL surface *)
let create_surface w h =
  Sdlvideo.create_RGB_surface
    [ `SWSURFACE ]
    ~w:w
    ~h:h
    ~bpp:32
    ~rmask:Int32.zero
    ~gmask:Int32.zero
    ~bmask:Int32.zero
    ~amask:Int32.zero

(** Get a display surface *)
let display w h = Sdlvideo.set_video_mode w h [`DOUBLEBUF]

(** Same with the size of a given surface *)
let display_for_matrix img =
  let w, h = Matrix.get_dims img in
    display w h

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
      | Sdlevent.QUIT -> failwith "User interruption"
      | _ -> wait_key ()

(** Convert a bool matrix (bool array array) to a black/white SDL surface *)
let surface_of_matrix matrix =
  let (w, h) = Matrix.get_dims matrix in
  let surface = create_surface w h in
    begin
      for x = 0 to w - 1 do
        for y = 0 to h - 1 do
          Sdlvideo.put_pixel_color surface x y (color_of_bool matrix.(x).(y));
        done;
      done;
      surface
    end

(** Display the corresponding SDL surface of a bool matrix on the dst display *)
let show_matrix mat dst =
  show (surface_of_matrix mat) dst
