open Matrix

let bool2color = function
    | true -> Sdlvideo.black
    | false -> Sdlvideo.white

let matrix_to_surface matrix =
    let h, w = Matrix.nbcols matrix, Matrix.nbrows matrix in
    let z = Int32.zero in
    let surface  = Sdlvideo.create_RGB_surface []
        ~w:w ~h:h ~bpp:8 ~rmask:z ~gmask:z ~bmask:z ~amask:z in
    begin
        for c = 0 to w - 1 do
            for r = 0 to h - 1 do
                let (x,y) = Matrix.coords (c,r) h in
                Sdlvideo.put_pixel_color surface x y (bool2color matrix.(r).(c))
            done
        done;
        surface
    end

