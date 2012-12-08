let _ =
  Image.sdl_init ();
  let fonts = Ttf.gen_chars () in
    for i = 0 to (Array.length fonts) - 1 do
      for j = 0 to (Array.length fonts.(i)) - 1 do
        let a = fonts.(i).(j) in
          Image.show a (Image.display_for_image a);
          Image.wait_key ();
      done
    done
