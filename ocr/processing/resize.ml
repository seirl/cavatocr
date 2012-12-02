let resize mat nw nh =
    let mat2 = Matrix.make nw nh false in
    let ow, oh = Matrix.get_dims mat in
    let ratio_x = (float ow) /. (float nw) in
    let ratio_y = (float oh) /. (float nh) in
    for x = 0 to nw - 1 do
        for y = 0 to nh - 1 do
            let ox = truncate (ratio_x *. float x) in
            let oy = truncate (ratio_y *.float y) in
            if ox >= 0 && ox < ow && oy >= 0 && oy < oh then
                mat2.(x).(y) <- mat.(ox).(oy);
        done
    done;
    mat2

