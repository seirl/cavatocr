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
let image2grey src dst =
    let (w,h) = Image.get_dims src in
    for y = 0 to h - 1 do
        for x = 0 to w - 1 do
            Sdlvideo.put_pixel_color dst x y
        (color2grey (Sdlvideo.get_pixel_color src x y ))
        done
    done

(** Binarization step *)
let seuil imageBW =
    let s = ref 0 in
    let (w,h) = Image.get_dims imageBW in
    for y = 0 to h - 1 do
        for x = 0 to w - 1 do
            let (a,_,_) = Sdlvideo.get_pixel_color imageBW x y in
            s := !s+a
        done
    done;
    !s / (w*h);


(** Pixel binarization *)
let transform (x,y,z) tolerance = match (x,y,z) with
    | (x,y,z) when x < tolerance -> false
    | (x,y,z) -> true

(** Image binarization *)
let binarise imageBw tolerance =
    let (w,h) = Image.get_dims imageBw in
    let arr = Array.make_matrix w h false in
    for y = 0 to h - 1 do
        for x = 0 to w - 1 do
            arr.(x).(y) <-
                (transform (Sdlvideo.get_pixel_color imageBw x y) tolerance)
        done;
    done;
    arr


(** Delete noize *)
let sorttable arraytable =
    for i = 0 to Array.length arraytable - 1 do
        let minplace = ref i
        and temp = arraytable.(i) in
        for j = i to Array.length (arraytable.(i)) - 1 do
            if arraytable.(j) < arraytable.(!minplace) then
                minplace := j
        done;
        arraytable.(i) <- arraytable.(!minplace) ;
        arraytable.(!minplace) <- temp
    done

let rec mathmedian l length = match l with
    | [] -> failwith "wat"
    | e::l when length = 5 -> e
    | _::l -> mathmedian l (length-1)
