open Matrix

let cartesian_to_polar (x,y) = 
    let (x,y) = (float x, float y) in
    (sqrt (x**2. +. y**2.), atan2 y x)

let polar_to_cartesian (r,t) =
    let (x,y) = (r *. cos t, r *. sin t) in
    (int_of_float x, int_of_float y)

let rotate_polar (r,t) angle =
    (r, t +. angle)

let rotate (x,y) angle =
    polar_to_cartesian (rotate_polar (cartesian_to_polar (x,y)) angle)

let newdims w h angle =
    let wx, wy = rotate (w,0) angle in
    let hx, hy = rotate (0,h) angle in
    (max wx hx, max wy hy)

let rotate_matrix src angle =
    let (ow, oh) = (Matrix.nbcols src, Matrix.nbrows src) in
    let (nw, nh) = newdims ow oh angle in
    let dst = Matrix.make nw nh 0 in
    begin
        for r = 0 to ow - 1 do
            for c = 0 to oh - 1 do
                let (x, y) = (c, oh - r - 1) in
                let (nx, ny) = rotate (x, y) angle in
                let (nc, nr) = (nh - ny - 1, nx) in
                dst.(nc).(nr) <- src.(r).(c)
            done
        done;
    dst
    end
