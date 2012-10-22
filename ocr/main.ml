let _ =
  begin
    Image.sdl_init ();
    let show img =
      let display = Image.display_for_image img in
        begin
          Image.show_matrix img display;
          Image.wait_key ();
        end
    in

    let img = (Image.load Sys.argv.(1)) in
    let display = Image.display_for_image img in
      Image.show_rgb_matrix img display;
      Image.wait_key ();

    let grey = Filters.image2grey img in
      Image.show_rgb_matrix grey display;
      Image.wait_key ();

    let bin = Filters.binarize grey in
      show bin;

    let edge = Filters.edge bin in
      show edge;
      show bin;

    let rotated = Rotate.rotate bin (Rotate.get_skew_angle bin) in
      show rotated;

    let lines = Blocks.lines_of_image rotated in
      List.iter show lines;

    let chars = match lines with
      | _ :: _ :: line :: _ -> Blocks.chars_of_line line
      | _ -> failwith "non"
    in
      List.iter show chars
  end
