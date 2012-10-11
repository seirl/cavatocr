let bool2color = function
    | true -> Sdlvideo.black
    | false -> Sdlvideo.white

let get_dims img = (
      (Sdlvideo.surface_info img).Sdlvideo.w,
      (Sdlvideo.surface_info img).Sdlvideo.h
)

let create_surface w h = Sdlvideo.create_RGB_surface [] ~w:w ~h:h ~bpp:8
    ~rmask:Int32.zero ~gmask:Int32.zero ~bmask:Int32.zero ~amask:Int32.zero 

let matrix_to_surface matrix =
    let h, w = Matrix.nbcols matrix, Matrix.nbrows matrix in
    let surface = create_surface w h in
    begin
        for c = 0 to w - 1 do
            for r = 0 to h - 1 do
                let (x,y) = Matrix.coords (c,r) h in
                Sdlvideo.put_pixel_color surface x y (bool2color matrix.(r).(c))
            done
        done;
        surface
    end

