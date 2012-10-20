let _ =
    Image.sdl_init ();
    let mat_rgb = Image.load Sys.argv.(1) in
    let mat = Filters.filter mat_rgb in
    let skew_angle = Rotate.get_skew_angle mat in
    let rotate_mat = Rotate.rotate mat skew_angle in
    Image.show surface display;
    Image.wait_key();
    let surface2 = Image.surface_of_matrix rotate_mat in
    let display2 = Image.display_for_image surface2 in
    Image.show surface2 display2;
    Image.wait_key();
    exit 0
