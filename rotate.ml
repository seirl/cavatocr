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

(*let rotate angle = function*)
