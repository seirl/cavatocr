(** Get the gray level of a color *)
let level (r,g,b) =
  (float(r) *. 0.3 +.
   float(g) *.  0.59 +.
   float(b) *. 0.11) /. 255.


(** Recreates the color from its grey level *)
let color2grey (r,g,b) =
  let grey = truncate (level (r,g,b) *. 255.)
  in (grey,grey,grey)


(** Turns an image into greyscale *)
let image2grey src =
  let (w,h) = Image.get_dims src in
  let dst = Matrix.make  w h (0,0,0) in
    for y = 0 to h - 1 do
      for x = 0 to w - 1 do
        dst.(x).(y) <- color2grey (Sdlvideo.get_pixel_color src x y)
      done
    done;
    src


let fst (a,_,_) = a


(** median Filter *)
let clean_bin image_grey =
  let (w, h) = Image.get_dims image_grey in
  let image_clean = Image.create_surface w h in
  let table = Array.make 9 0 in
    begin
      for y = 1 to h - 2 do
        for x = 1 to w - 2 do
          table.(0) <- fst (Sdlvideo.get_pixel_color image_grey x y);
          table.(1) <- fst (Sdlvideo.get_pixel_color image_grey (x-1) (y-1));
          table.(2) <- fst (Sdlvideo.get_pixel_color image_grey (x) (y-1));
          table.(3) <- fst (Sdlvideo.get_pixel_color image_grey (x+1) (y-1));
          table.(4) <- fst (Sdlvideo.get_pixel_color image_grey (x-1) (y));
          table.(5) <- fst (Sdlvideo.get_pixel_color image_grey (x+1) (y));
          table.(6) <- fst (Sdlvideo.get_pixel_color image_grey (x-1) (y+1));
          table.(7) <- fst (Sdlvideo.get_pixel_color image_grey (x) (y+1));
          table.(8) <- fst (Sdlvideo.get_pixel_color image_grey (x+1) (y+1));

          Array.fast_sort (-) table;
          let m = table.(4) in
            Sdlvideo.put_pixel_color image_clean x y (m,m,m)
        done;
      done;
      image_clean
    end


(** Edge detection *)
let edge image_bin =
  let(w, h) = Matrix.get_dims image_bin in
  let image_edge = Matrix.make w h false
  and iob = Tools.int_of_bool in
    begin
      for x = 1 to w - 2 do
        for y = 1 to h - 2 do
          let edge_average =
            (
              iob (image_bin.(x-1).(y-1) )
              + (* plus *)
              iob (image_bin.(x).(y-1)   )
              + (* plus *)
              iob (image_bin.(x+1).(y-1) )
              + (* plus *)
              iob (image_bin.(x-1).(y)   )
              + (* plus *)
              iob (image_bin.(x+1).(y)   )
              + (* plus *)
              iob (image_bin.(x-1).(y+1) )
              + (* plus *)
              iob (image_bin.(x).(y+1)   )
              + (* plus *)
              iob (image_bin.(x+1).(y+1) )
            )/8
          in
            image_edge.(x).(y) <- (edge_average < iob (image_bin.(x).(y)))
        done;
      done;

      (* Finish with image's own edges *)
      for x = 0 to w - 1 do
        image_edge.(x).(0) <- image_bin.(x).(0);
        image_edge.(x).(h-1) <- image_bin.(x).(h-1)
      done;
      for y = 0 to h - 1 do
        image_edge.(0).(y) <- image_bin.(0).(y);
        image_edge.(w-1).(y) <- image_bin.(w-1).(y)
      done;

      image_edge
    end


(** RLSA *)
let rlsa mat =
  let (x,y) = Matrix.get_dims mat in
  let rlsaMat = Array.make_matrix x y false in
    begin
      for yi=1 to y-2 do
        for xi=1 to x-2 do
          if mat.(xi).(yi) = true then (*noir*)
            rlsaMat.(xi).(yi) <- true
          else
              if (   Tools.int_of_bool(mat.(xi-1).(yi-1))
                     +
                     Tools.int_of_bool(mat.(xi).(yi-1))
                     +
                     Tools.int_of_bool(mat.(xi+1).(yi-1))
                     +
                     Tools.int_of_bool(mat.(xi-1).(yi))
                     +
                     Tools.int_of_bool(mat.(xi+1).(yi))
                     +
                     Tools.int_of_bool(mat.(xi-1).(yi+1))
                     +
                     Tools.int_of_bool(mat.(xi).(yi+1))
                     +
                     Tools.int_of_bool(mat.(xi+1).(yi+1))
              ) >= 4 then
                rlsaMat.(xi).(yi) <- true
              else
                rlsaMat.(xi).(yi) <- false
        done;
      done;
      rlsaMat
    end


(** Image binV2 *)
let ecartype imageBw x y =
  let s x = x*x in
  let sf x  = x *. x in
    sqrt(
      (1. /. 9. *.
       float(
         s(fst(Sdlvideo.get_pixel_color imageBw x y))
         + s(fst(Sdlvideo.get_pixel_color imageBw (x-1) (y-1)))
         + s(fst(Sdlvideo.get_pixel_color imageBw  x (y-1)))
         + s(fst(Sdlvideo.get_pixel_color imageBw (x+1) (y-1)))
         + s(fst(Sdlvideo.get_pixel_color imageBw (x-1) (y)))
         + s(fst(Sdlvideo.get_pixel_color imageBw (x+1) (y)))
         + s(fst(Sdlvideo.get_pixel_color imageBw (x-1) (y+1)))
         + s(fst(Sdlvideo.get_pixel_color imageBw (x) (y+1)))
         + s(fst(Sdlvideo.get_pixel_color imageBw (x+1) (y+1)))
       )
      )
      -.
      sf ( 1. /. 9. *.
           float(
             fst(Sdlvideo.get_pixel_color imageBw x y)
             + fst(Sdlvideo.get_pixel_color imageBw (x-1) (y-1))
             + fst(Sdlvideo.get_pixel_color imageBw  x (y-1))
             + fst(Sdlvideo.get_pixel_color imageBw (x+1) (y-1))
             + fst(Sdlvideo.get_pixel_color imageBw (x-1) (y))
             + fst(Sdlvideo.get_pixel_color imageBw (x+1) (y))
             + fst(Sdlvideo.get_pixel_color imageBw (x-1) (y+1))
             + fst(Sdlvideo.get_pixel_color imageBw (x) (y+1))
             + fst(Sdlvideo.get_pixel_color imageBw (x+1) (y+1))
           )
      )
    )


let moy  imageBw x y =
  (fst (Sdlvideo.get_pixel_color imageBw x y) +
   fst (Sdlvideo.get_pixel_color imageBw (x-1) (y-1)) +
   fst (Sdlvideo.get_pixel_color imageBw x (y-1)) +
   fst (Sdlvideo.get_pixel_color imageBw (x+1) (y-1)) +
   fst (Sdlvideo.get_pixel_color imageBw (x-1) y) +
   fst (Sdlvideo.get_pixel_color imageBw (x+1) y) +
   fst (Sdlvideo.get_pixel_color imageBw (x-1) (y+1)) +
   fst (Sdlvideo.get_pixel_color imageBw (x) (y+1)) +
   fst (Sdlvideo.get_pixel_color imageBw (x+1) (y+1)))/9


let fixseuil imageBw x y =
  int_of_float(
    float((moy imageBw x y))
    *.
    (1. +. 0.2 *. ((ecartype imageBw x y) /. 128.) -. 1.)
  )


let binarize image_grey =
  let (w, h) = Image.get_dims image_grey in
  let imageBin = Matrix.make w h false in
    for x = 0 to w - 1 do
      for y = 0 to h - 1 do
        imageBin.(x).(y) <-
        (fst (Sdlvideo.get_pixel_color image_grey x y)) < 180
      done;
    done;
    imageBin

let filter img =
  binarize (image2grey img)
