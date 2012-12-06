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

let local_moy mat div_w div_h =
  let ow, oh = Matrix.get_dims mat in
  let part_w, part_h = (ow / div_w, oh / div_w) in
  let moymat = Matrix.make div_w div_h 0.0 in
    for i = 0 to div_w - 1 do
      for j = 0 to div_h - 1 do
        let sum = ref 0 in
        for x = i * part_w to i * (part_w + 1) - 1 do
          for y = j * part_h to j * (part_h + 1) - 1 do
            sum := !sum + Tools.int_of_bool mat.(x).(y)
          done
        done;
        moymat.(i).(j) <- (float !sum) /. (float (part_w * part_h))
      done
    done
