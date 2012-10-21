let nbcols = Array.length
let nbrows x = Array.length x.(0)
let get_dims m = (nbcols m, nbrows m)
let make = Array.make_matrix
let int_of_bool (b: bool) = if b then 1 else 0

(** Load an image as a matrix of three color: (int,int,int) array array *)
let load name =
  let surface = Sdlloader.load_image name in
  let (w, h) = Image.get_dims surface in
  let mat = make w h (0,0,0) in
    for x = 0 to w - 1 do
      for y = 0 to h - 1 do
        mat.(x).(y) <- Sdlvideo.get_pixel_color surface x y
      done;
    done;
    mat

let print_matrix mat =
    for r = 0 to (nbrows mat) - 1 do
        for c = 0 to (nbcols mat) - 1 do
            Printf.printf "%d " (int_of_bool mat.(r).(c));
        done;
        Printf.printf "\n";
    done

let display_for_image img =
  let w, h = get_dims img in
    Image.display w h

(** Convert a bool matrix (bool array array) to a black/white SDL surface *)
let surface_of_matrix matrix =
  let (w, h) = get_dims matrix in
  let surface = Image.create_surface w h in
    begin
      for x = 0 to w - 1 do
        for y = 0 to h - 1 do
          Sdlvideo.put_pixel_color surface x y
            (Image.color_of_bool matrix.(x).(y));
        done;
      done;
      surface
    end

(** Convert a rgb matrix ((int,int,int) array array) to a SDL surface *)
let surface_of_rgb_matrix matrix =
    let (w, h) = get_dims matrix in
    let surface = Image.create_surface w h in
    begin
        for x = 0 to w - 1 do
            for y = 0 to h - 1 do
                Sdlvideo.put_pixel_color surface x y matrix.(x).(y)
            done
        done;
        surface
    end

(** Display the corresponding SDL surface of a bool matrix on the dst display *)
let show_matrix mat dst =
  Image.show (surface_of_matrix mat) dst

(** Display the corresponding SDL surface of a rgb matrix on the dst display *)
let show_rgb_matrix mat dst =
  Image.show (surface_of_rgb_matrix mat) dst
