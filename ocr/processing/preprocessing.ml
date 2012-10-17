(* Dimensions d'une image *)
let get_dims img =
  ((Sdlvideo.surface_info img).Sdlvideo.w, (Sdlvideo.surface_info img).Sdlvideo.h)

  (* init de SDL *)
let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end

  (* attendre une touche ... *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
  match e with
  Sdlevent.KEYDOWN _ -> ()
      | _ -> wait_key ()

      (*
      show img dst
      affiche la surface img sur la surface de destination dst (normalement l'écran)
*)
let show img dst =
  let d = Sdlvideo.display_format img in
  Sdlvideo.blit_surface d dst ();
  Sdlvideo.flip dst
(*met mon image enoir et blanc*)
let level (r,g,b) = ( float_of_int(r) *. 0.3 +. float_of_int(g) *.  0.59 +.
float_of_int(b) *. 0.11) /. 255. 

let color2grey (r,g,b) = let grey = int_of_float (level (r,g,b) *. 255.) in (grey,grey,grey)


let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end


let image2grey src dst =
  let (w,h) = get_dims src in 
  for i=0 to w - 1 do
    for j=0 to h - 1 do 
      Sdlvideo.put_pixel_color dst i j (color2grey (Sdlvideo.get_pixel_color src i j )) 
    done
  done
  (* fixage du seuil de binarisation  avec un s definie avant (je sais c est
    deguelasse) *)
let seuil imageBW s =    
  let (w,h) = get_dims imageBW in
    for i=0 to w - 1 do 
      for j = 0 to h - 1 do
              let (a,_,_)= Sdlvideo.get_pixel_color imageBW i j in 
              s:=!s+a 
      done
    done ; 
    s:= !s /(w*h); 
    !s
    (*binarisation*)
     

let transform (x,y,z) tolerance = match (x,y,z)with 
|(x,y,z) when x < tolerance -> (0,0,0)
|(x,y,z) -> (255,255,255) 


let binarise imageBw imageBin tolerance = 
  let (w,h) = get_dims imageBw in
     for i=0 to w - 1 do 
      for j =0 to h - 1 do
       Sdlvideo.put_pixel_color imageBin i j
       (transform(Sdlvideo.get_pixel_color imageBw i j ) tolerance) 
      done
     done

    (* suppression de bruit *) 

(*let rec mathmedian l*) 
(* main *)
let main () =
  begin
    (* Nous voulons 1 argument *)
    if Array.length (Sys.argv) < 2 then
      failwith "Il manque le nom du fichier!";
      (* Initialisation de SDL *)
      sdl_init ();
      (* Chargement d'une image *)
      let img = Sdlloader.load_image Sys.argv.(1) in
      (* On récupère les dimensions *)
      let (w,h) = get_dims img in
      (* On crée la surface d'affichage en doublebuffering *)
      let display = Sdlvideo.set_video_mode w h [`DOUBLEBUF] in
      (* on affiche l'image *)
      show img display;
      (* on attend une touche *)
      wait_key ();
      let img2 =Sdlvideo.create_RGB_surface_format img [] w h in 
      image2grey img img2;
      show img2 display;
      wait_key ();
      let imgbin = Sdlvideo.create_RGB_surface_format img [] w h in 
      binarise img2 imgbin 126;
      show imgbin display;
      wait_key (); 

      (* on quitte *)
      exit 0
  end

let _ = main ()
