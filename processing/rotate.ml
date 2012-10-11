let pi = 3.14159265

let cartesian_to_polar (x,y) = 
    let (x,y) = (float x, float y) in
    (sqrt (x**2. +. y**2.), atan2 y x)

let polar_to_cartesian (r,t) =
    let (x,y) = (r *. cos t, r *. sin t) in
    (int_of_float x, int_of_float y + 1)

let rotate_polar (r,t) angle =
    (r, t +. angle)

let rotate (x,y) angle =
    polar_to_cartesian (rotate_polar (cartesian_to_polar (x,y)) angle)

let newdims w h angle =
    let wx, wy = rotate (w,0) angle in
    let hx, hy = rotate (0,h) angle in
    ((max (abs wx) (abs hx)) + 2, (max (abs wy) (abs hy)) + 2)

let print_matrix mat =
    for r = 0 to Matrix.nbrows mat - 1 do
        for c = 0 to Matrix.nbcols mat - 1 do
            Printf.printf "%B " mat.(r).(c);
        done;
        Printf.printf "\n";
    done

let rotate_matrix src angle =
    let (ow, oh) = (Matrix.nbcols src, Matrix.nbrows src) in
    let (nw, nh) = newdims ow oh angle in
    let dst = Matrix.make nw nh false in
    begin
        for r = 0 to ow - 1 do
            for c = 0 to oh - 1 do
                let (x, y) = Matrix.coords (c,r) oh in
                let (x, y) = (x - ow / 2, y - oh / 2) in
                let (nx, ny) = rotate (x, y) angle in
                let (nc, nr) = Matrix.pos (nx + nw / 2, ny + nh / 2) nh in
                Printf.printf "%d %d\n" r c;
                Printf.printf "%d %d\n" nr nc;
                print_matrix dst;
                dst.(nr).(nc) <- src.(r).(c)
            done
        done;
    dst
    end

let _ =
    let mat = [| [| false ; false ; true |];
        [| true ; false ; true |];
        [| false ; false ; true |];
        [| false ; true ; true |];
    |] in 
    print_matrix (rotate_matrix mat (pi *. 2.));
    let x,y = rotate (5,5) (pi *. 2.) in
    Printf.printf "%d %d" x y
