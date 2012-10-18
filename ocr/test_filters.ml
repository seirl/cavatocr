let _ =
  begin
    Image.sdl_init ();

    let img = Image.load Sys.argv.(1) in
    let display = Image.display_for_image img in

    let img_grey = Filters.image2grey img in
    let early_laplace = Filters.laplacian img_grey in
    let img_bin = Filters.binarize img_grey in
    let img_clean = Filters.clean_bin img_bin in
    let img_laplace = Filters.laplacian img_clean in

        Image.show img display;
        Image.wait_key ();

        Image.show img_grey display;
        Image.wait_key ();

        Image.show early_laplace display;
        Image.wait_key ();

        Image.show img_bin display;
        Image.wait_key ();

        Image.show img_clean display;
        Image.wait_key ();

        Image.show img_laplace display;
        Image.wait_key ()
  end
