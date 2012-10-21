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
  let (w, h) = Matrix.get_dims src in
  let dst = Matrix.make w h (0,0,0) in
    for x = 0 to w - 1 do
      for y = 0 to h - 1 do
        dst.(x).(y) <- (color2grey (src.(x).(y)))
      done;
    done;
    dst

(** give x of (x,y,z) *)
let first (a,_,_) = a

(** Pixel binarization *)
let transform (x,y,z) tolerance = x >= tolerance

(** Image binarization *)
let binarize image_grey =
  let (w, h) = Matrix.get_dims image_grey in
  let imageBin = Matrix.make w h false in
    for x = 0 to w - 1 do
      for y = 0 to h - 1 do
        imageBin.(x).(y) <- (first(image_grey.(x).(y)) < 180)
      done;
    done;
    imageBin

let sorttable arraytable =
  for i = 0 to Array.length arraytable - 1 do
    let minplace = ref i
    and temp = arraytable.(i) in
      for j = i to Array.length arraytable - 1 do
        if arraytable.(j) < arraytable.(!minplace) then
          minplace := j
      done;
      arraytable.(i) <- arraytable.(!minplace) ;
      arraytable.(!minplace) <- temp
  done

(** median Filter *)
let clean_bin image_grey =
  let (w, h) = Matrix.get_dims image_grey in
  let image_clean = Matrix.make w h (0,0,0) in
  let table = Array.make 9 0 in
    begin
      for y = 1 to h - 2 do
        for x = 1 to w - 2 do
          table.(0) <-  first (image_grey.(x).(y)     );
          table.(1) <-  first (image_grey.(x-1).(y-1) );
          table.(2) <-  first (image_grey.(x).(y-1)   );
          table.(3) <-  first (image_grey.(x+1).(y-1) );
          table.(4) <-  first (image_grey.(x-1).(y)   );
          table.(5) <-  first (image_grey.(x+1).(y)   );
          table.(6) <-  first (image_grey.(x-1).(y+1) );
          table.(7) <-  first (image_grey.(x).(y+1)   );
          table.(8) <-  first (image_grey.(x+1).(y+1) );

          sorttable table;
          let m = table.(4) in
            image_clean.(x).(y) <- (m,m,m)
        done;
      done;
      image_clean
    end

(** (Laplacian ?) Edge detection *)
let edge image_bin =
  let(w, h) = Matrix.get_dims image_bin in
  let image_edge = Matrix.make w h false
  and iob = Matrix.int_of_bool in
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

let filter image = edge (binarize (clean_bin (image2grey image)))
let filter_no_clean image = edge (binarize (image2grey image))
