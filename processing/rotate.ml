let pi = 3.14159

let rotate img angle =
    let (cos_a, sin_a) = (cos angle, sin angle) in
    let (w, h) = Image.get_dims img in
    let wo = int_of_float (float w *. (abs_float cos_a)
        +. float h *. (abs_float sin_a)) in
    let ho = int_of_float (float h *. (abs_float cos_a)
        +. float w *. (abs_float sin_a)) in
    let img2 = Sdlvideo.create_RGB_surface_format img [] wo ho in
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
                let px = Sdlvideo.get_pixel_color img xo yo in
                Printf.printf "%d %d %d %d " xo yo x y;
                Printf.printf "set ";
                Sdlvideo.put_pixel_color img2 x y px;
                Printf.printf "done\n";
        done
    done;
    img2

