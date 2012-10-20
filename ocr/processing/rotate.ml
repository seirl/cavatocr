(** This module can detect the skew angle of an image and rotate it *)

(** π *)
let pi = 3.14159

(** Rotate the image matrix by the specified angle *)
let rotate mat angle =
    let (cos_a, sin_a) = (cos angle, sin angle) in
    let (w, h) = Matrix.get_dims mat in
    let wo = int_of_float (float w *. (abs_float cos_a)
        +. float h *. (abs_float sin_a)) in
    let ho = int_of_float (float h *. (abs_float cos_a)
        +. float w *. (abs_float sin_a)) in
    let mat2 = Matrix.make wo ho false in
    let (x_center, y_center) = (w/2, h/2) in
    let (xo_center, yo_center) = (wo/2, ho/2) in
    for y=0 to ho - 1 do
        for x = 0 to wo - 1 do
            let xo = int_of_float (cos_a *. float (x - xo_center)
                +. sin_a *. float (y - yo_center) +. float x_center) in
            let yo = int_of_float (-.sin_a *. float (x - xo_center)
                +. cos_a *. float (y - yo_center) +. float y_center) in
            if xo >= 0 && xo < w && yo >=0 && yo < h
            && x >= 0 && x < wo && y >=0 && y < ho
            then
                let px = mat.(xo).(yo) in
                mat2.(x).(y) <- px;
        done
    done;
    mat2

(** Convert a radian angle into a degree angle *)
let to_degrees = function rad -> (rad *. 180.) /. pi

(** Convert a degree angle into a radian angle *)
let to_radians = function deg -> (deg *. pi) /. 180.


(** Count the pixels of the given row from start to end *)
let pixels_count mat row st en =
    let count = ref 0 in
    for i = st to en do
        count := count + if mat.(row).(i) then 1 else 0
    done;
    count

(** Cast a ray through the matrix with the given variations of coordinates *)
let cast_ray mat row dx dy =
    let row = ref row in
    let bits = ref 0 in
    let st = ref 0 in
    let en = ref 0 in
    let (w,h) = Matrix.get_dims mat in
    while !start < w || !row < 0 || !row > h do
        en := start + dx;
        en := if !en > w then w else en;
        bits := bits + pixels_count mat row st en;
        st := en;
        row := row + dy
    done;
    bits

(** Get the chance of an angle to be the right orientation of the text *)
let histogram mat angle =
    let sample = 1 in
    let angle_diff = tan(angle) in
    let (w,h) = Matrix.get_dims mat in
    let diff_y = - (int_of_float ((float w) *. angle_diff)) in
    let (min_y, max_y) = (max 0 diff_y, min h (h + diff_y)) in
    let num_rows = (max_y - min_y) / sample + 1 in
    let dy = if angle < 0. then -1 else 1 in
    let dx = int_of_float ((float dy) /. angle_diff) in
    let rows = Array.make num_rows 0 in
    for i = 0 to num_rows do
        rows.(i) <- cast_ray mat (min_y + i) dx dy)
    done;
    let moy = (Array.fold_left (+) 0 rows) / num_rows in
    let sum = ref 0 in
    let sqr x = x * x in
    for i = 0 to num_rows do
        sum := sum + sqr (rows.(i) - moy)
    done;
    sum / moy

(** Get the skew angle of the image matrix *)
let get_skew_angle mat =
    let hist_opt = ref 0.
    and angle_opt = ref 0. in
    (* First approximation with integer degrees *)
    for i = -45 to 45 do
        let angle = (float i) in
        let hist = histogram mat (to_radians angle) in
        if hist > !hist_opt then
            hist_opt := hist;
            angle_opt := angle;
    done;
    (* Second pass with tenth of degrees *)
    for i = 10 * (int_of_float !angle_opt) + 10
    to 10 * (int_of_float !angle_opt) + 10 do
        let angle = (float i) /. 10. in
        let hist = histogram mat (to_radians angle) in
        if hist > !hist_opt then
            begin
                hist_opt := hist;
                angle_opt := angle;
            end
    done;
    (to_radians !angle_opt)
    

