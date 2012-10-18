(** Get the gray level of a color *)
let level (r,g,b) =
    (float_of_int(r) *. 0.3 +.
     float_of_int(g) *.  0.59 +.
     float_of_int(b) *. 0.11) /. 255.

(** Recreates the color from its grey level *)
let color2grey (r,g,b) =
    let grey = int_of_float (level (r,g,b) *. 255.)
    in (grey,grey,grey)

(** Turns an image into greyscale *)
let image2grey src =
  let (w,h) = Image.get_dims src in
  let dst = Image.create_surface w h in
    for y = 0 to h - 1 do
      for x = 0 to w - 1 do
        Sdlvideo.put_pixel_color dst x y
          (color2grey (Sdlvideo.get_pixel_color src x y ))
      done;
    done;
    dst

(** give x of (x,y,z) *)
let g = function
|(a,_,_) -> a 

(** Pixel binarization *)
let transform (x,y,z) tolerance = match (x,y,z) with
    | (x,y,z) when x < tolerance -> false
    | (x,y,z) -> true

(** Image binarization *)
let binarize imageBw =
  let(w,h) =Image.get_dims imageBw in
  let imageBin = Image.create_surface w h in
    begin
      for y = 0 to h do
        for x = 0 to w do
          if g(Sdlvideo.get_pixel_color imageBw x y) < 180 then
            Sdlvideo.put_pixel_color imageBin x y (0,0,0)
          else
            Sdlvideo.put_pixel_color imageBin x y (255,255,255)
        done;
      done;
      imageBin
    end

(** Laplacian edge detection finalisation *)
let laplacian_end imageBin = 
        let (w,h)= Image.get_dims imageBin in
        for x = 0 to w - 1 do 
               if g (Sdlvideo.get_pixel_color imageBin x 0) < 127 then
                     Sdlvideo.put_pixel_color imageBin x 0 (0,0,0)
               else Sdlvideo.put_pixel_color imageBin x 0 (255,255,255);

               if g (Sdlvideo.get_pixel_color imageBin x (h-1)) < 127 then
                     Sdlvideo.put_pixel_color imageBin x (h-1)  (0,0,0)
               else Sdlvideo.put_pixel_color imageBin x (h-1) (255,255,255)
        done;
        
        for y = 0 to h -1 do
               if g (Sdlvideo.get_pixel_color imageBin 0 y ) < 127 then
                       Sdlvideo.put_pixel_color imageBin 0 y (0,0,0)
               else Sdlvideo.put_pixel_color imageBin 0 y (255,255,255);

               if g (Sdlvideo.get_pixel_color imageBin (w-1) y ) < 127 then
                     Sdlvideo.put_pixel_color imageBin (w-1) y (0,0,0)
               else Sdlvideo.put_pixel_color imageBin (w-1) y
                      (255,255,255) 
        done

(** Laplacian edge detection *)
let laplacian imageBw =
  let(w,h) =Image.get_dims imageBw in
  let imageBin = Image.create_surface w h in
    begin
      for y = 1 to h - 2 do
        for x = 1 to w - 2 do
          if
            (
                g(Sdlvideo.get_pixel_color imageBw (x-1) (y-1))
                +
                g(Sdlvideo.get_pixel_color imageBw  x (y-1))
                +
                g(Sdlvideo.get_pixel_color imageBw (x+1) (y-1))
                +
                g(Sdlvideo.get_pixel_color imageBw (x-1) (y))
                +
                g(Sdlvideo.get_pixel_color imageBw (x+1) (y))
                +
                g(Sdlvideo.get_pixel_color imageBw (x-1) (y+1))
                +
                g(Sdlvideo.get_pixel_color imageBw (x) (y+1))
                +
                g(Sdlvideo.get_pixel_color imageBw (x+1) (y+1))
            )/8
          < (* Less than *)
            g(Sdlvideo.get_pixel_color imageBw x y )
          then
            Sdlvideo.put_pixel_color imageBin x y (0,0,0)
          else
            Sdlvideo.put_pixel_color imageBin x y (255,255,255)
        done;
      done;
      laplacian_end imageBin;
      imageBin
    end

let clean_bin img = img 

let rec mathmedian l length = match l with
    | [] -> failwith "wat"
    | e::l when length = 5 -> e
    | _::l -> mathmedian l (length-1)