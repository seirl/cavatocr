let _ =
  begin
    Image.sdl_init ();

    let img = Image.load Sys.argv.(1) in
    let display = Image.display_for_image img in
    let img_bin = Preprocessing.binarise img 120 in
    let img_rot = Rotate.rotate img_bin 90. in
    let lines = Blocks.get_lines img_rot in
    let surface_lines = List.map (Image.surface_of_matrix) lines in
      List.iter (fun img -> Image.show img display) surface_lines
  end
