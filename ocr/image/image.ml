(* Get the dimensions of an SDL surface: a couple (witdh, height) *)
let get_dims img =
(
      (Sdlvideo.surface_info img).Sdlvideo.w,
      (Sdlvideo.surface_info img).Sdlvideo.h
)

(* Initialize SDL *)
let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end

(* Load an image as a surface *)
let load = Sdlloader.load_image

(* Get a display surface *)
let display w h = Sdlvideo.set_video_mode w h [`DOUBLEBUF]
(* Same with the size of a given surface *)
let display_for_image img =
  let w, h = get_dims img in
    display w h

(* Display an SDL surface on the dst display *)
let show img dst =
  let d = Sdlvideo.display_format img in
    Sdlvideo.blit_surface d dst ();
    Sdlvideo.flip dst

(* Wait for a key to be pressed before continue *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
    match e with
        Sdlevent.KEYDOWN _ -> ()
      | _ -> wait_key ()

let color_of_bool = function
    | true -> Sdlvideo.black
    | false -> Sdlvideo.white

(* Initialize an SDL surface *)
let create_surface w h = Sdlvideo.create_RGB_surface [] ~w:w ~h:h ~bpp:8
    ~rmask:Int32.zero ~gmask:Int32.zero ~bmask:Int32.zero ~amask:Int32.zero 

(* Convert a bool matrix (array array) to a black/white SDL surface *)
let surface_of_matrix matrix =
    let w, h = Matrix.nbcols matrix, Matrix.nbrows matrix in
    let surface = create_surface w h in
    begin
        for c = 0 to w - 1 do
            for r = 0 to h - 1 do
                let (x,y) = (c,r) in
                Sdlvideo.put_pixel_color surface x y (color_of_bool matrix.(r).(c))
            done
        done;
        surface
    end
