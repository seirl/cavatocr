let _ =
    Image.sdl_init ();
    let surface = Image.load Sys.argv.(1) in
    let display = Image.display_for_image surface in
    let mat = (Preprocessing.binarise surface (Preprocessing.seuil surface)) in
    let rotate_mat = Rotate.rotate (Preprocessing.sorttable mat) 0.2 in
    Image.show surface display;
    Image.wait_key();
    let surface2 = Image.surface_of_matrix rotate_mat in
    let display2 = Image.display_for_image surface2 in
    Image.show surface2 display2;
    Image.wait_key();
    exit 0
