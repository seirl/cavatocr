let _ =
  begin
    Image.sdl_init ();
    let show img =
      let display = Image.display_for_matrix (img:bool array array) in
        begin
          Image.show_matrix img display;
          Image.wait_key ();
        end
    in

    let img = (Image.load Sys.argv.(1)) in
    let display = Image.display_for_image img in
      Image.show img display;
      Image.wait_key();

      Filters.image2grey img;
      Image.show img display;
      Image.wait_key();

    let mat = Filters.binarize img in
      show mat;

    let mat = Filters.rlsa mat in
      show mat;


    (*
    let edge = Filters.edge bin in
      show edge;
      show bin;
    *)
    (*for i = -25 to 25 do
    Rotate.trace_histogram bin (Rotate.to_radians (float i));
    show bin;
    done;
    show bin;*)
    let angle = Rotate.get_skew_angle mat in
    let rotated = Rotate.rotate mat angle in
      show rotated;
      show (Rotate.trace_histogram mat angle);

    (* let lines = Blocks.chars_of_image bin in
      List.iter show lines;
      List.iter (List.iter (List.iter show)) lines*)

      ()
  end
