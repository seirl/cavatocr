let _ = Random.self_init ()
let is_nan x = x <> x

let fob = function true -> 1. | false -> 0.
and bof x = x > 0.5

class ['a] weights_matrix x y (init:'a) =
object (s)
  val pixels = Array.make_matrix x y init
  val dim_X = x
  val dim_Y = y

  method get_X = dim_X
  method get_Y = dim_Y
  method set x y p = pixels.(x).(y) <- p
  method get x y = pixels.(x).(y)

  method map f =
    for y=0 to dim_Y - 1 do
      for x=0 to dim_X - 1 do
        s#set x y (f x y (s#get x y))
      done;
    done

  method iter (f:int -> int -> 'a -> unit) =
    for y=0 to dim_Y-1 do
      for x=0 to dim_X-1 do
        f x y (s#get x y)
      done;
    done
end

class layer in_size size f f' rate momentum =
object(self: 'layer)

  val weights = new weights_matrix in_size size 0. 
  val prods = Array.make size 0.
  val outputs = Array.make size 0.
  val deltas = Array.make size 0.
  val prev_err = Array.make size 0.
  val mutable input = Array.make in_size 0.

  method get_outputs = outputs
  method get_deltas = deltas
  method get_weights = weights
  method get_size = size

  initializer
    weights#map (fun _ _ _ -> (Random.float 2.) -. 1.)

  method error expected =
    let sum = ref 0. and sqr x = x*.x in
      for i = 0 to size - 1 do
        sum := !sum +. sqr ((fob expected.(i)) -. outputs.(i));
      done;
      !sum /. 2.

  method process inp =
    input <- inp;
    for i = 0 to size - 1 do
      for j = 0 to in_size - 1 do
        prods.(i) <- prods.(i) +.  input.(j) *. weights#get j i;
      done;
      outputs.(i) <- f prods.(i);
    done

  method calc_deltas_first expected =
    for i = 0 to size - 1 do
      deltas.(i) <- (fob expected.(i)) -. outputs.(i);
    done;

  method calc_deltas (prev_lay: 'layer) =
    for i = 0 to size - 1 do
      for j = 0 to prev_lay#get_size - 1 do
      deltas.(i) <- deltas.(i) +. ((prev_lay#get_weights)#get i j)
                                *. (prev_lay#get_deltas).(j);
      done;
    done;

  method update_weights =
    let err = ref 0. in
    for j = 0 to size - 1 do
      err := 0.;
      for i = 0 to in_size - 1 do
        err := rate *. deltas.(j) *. input.(i) *. (f' prods.(j)); 
        let w = weights#get i j in
        weights#set i j ((weights#get i j) +. !err +. momentum *. prev_err.(j));
      done;
      prev_err.(j) <- !err;
    done

method update_weights_first =
    let err = ref 0. in
    for j = 0 to size - 1 do
      err := 0.;
      for i = 0 to in_size - 1 do
        err := rate *. deltas.(j) *. input.(i);
        weights#set i j ((weights#get i j) +. !err +. momentum *. prev_err.(j));
      done;
      prev_err.(j) <- !err;
    done

end


class t sizes (chars: char array) =
object(self)

  val size = Array.length sizes
  val sigmoid = fun x -> 1. /. (1. +. exp (-. x /. 0.4))
  val d_sigmoid = fun x ->
    let x = (max x (-.250.)) in
    let x = (min x 290.) in
    let e = exp (-.x /. 0.4) in
      e /. (0.4 *. ((1. +. e)**2.))
  val r = 0.2 (* taux d'aprentissage *)
  val m = 0.2 (* inertie d'apentrentissage *)
  val mutable layers = [||]

  initializer
      layers <- Array.init (size - 1)
            (fun i -> new layer sizes.(i) sizes.(i+1) sigmoid d_sigmoid r m);

  method print_output =
    let str = ref "[" and out = layers.(size - 2)#get_outputs in
      for i = 0 to sizes.(size - 1) - 2 do
        str := !str ^ (string_of_float out.(i)) ^ ";";
      done;
      str := !str ^ (string_of_float  out.(sizes.(size - 1) - 1)) ^ "]\n";
      print_string "Output MLP:\n";
      print_string !str

  method process input =
    (* print_string "Input:\n"; *)
    layers.(0)#process input; 
    for i = 1 to size - 2 do
      layers.(i)#process (layers.(i-1)#get_outputs);
    done
    (* self#print_output *)

  method find_char =
    let out = layers.(size - 2)#get_outputs in
    let index = ref 0 and max = ref 0. in
      for i = 0 to sizes.(size - 1) - 1 do
        if out.(i) > !max then
          begin
          max := out.(i);
          index := i;
          end;
      done;
    chars.(!index)

  method out_from_char c =
    Array.init (Array.length chars) (fun i -> c = chars.(i))

  method learn input output_c =
    let output = self#out_from_char output_c in
    self#process input;
    layers.(size - 2)#calc_deltas_first output;
    layers.(size - 2)#update_weights_first;
    for i = size - 3 downto 0 do
      layers.(i)#calc_deltas layers.(i + 1);
      layers.(i)#update_weights;
    done;
    Printf.printf "\nError: %f\nDetected: %c\n"
      (layers.(size - 2)#error output) self#find_char

  method save path =
    let file = open_out path in
      Marshal.to_channel file self [Marshal.Closures]

end


let from_file path =
  let file = open_in path in
  let res = Marshal.from_channel file in
    close_in file;
    res

