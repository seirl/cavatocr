let _ = Random.self_init ()

let fob = function true -> 0.95 | false -> 0.05

class t sizes chars =
object(self)

  val size = Array.length sizes
  val sigmoid = function x -> 1. /. (1.+.exp (-.x))
  val d_sigmoid = function x ->
        let e = exp (-.x /. 0.4) in
          e /. (0.4 *. ((1. +. e)**2.))
  
  (** Learning rate *)
  val r = 0.1

  (** Learning intertia *)
  val m = 0.2

  val layers = Array.init self#size
            (fun i -> new layer sizes.(i) sizes.(i+1) sigmoid d_sigmoid r m)

  method process input =
    layers.(0)#process input; 
    for i = 1 to size - 1 do
      layer.(i)#process (layer.(i-1)#get_output);
    done;

  method find_char =
    let out = layer.(size - 1)#get_output in
    let i = ref 0 in
    while not out.(i) && i < sizes.(size - 1) do
      incr i;
    done;
    chars.(i)

  method out_from_char c =
    Array.init (Array.length chars) (fun _ i -> fob (c = chars.(i)))

  method learn input output =
    layers.(size - 1)#calc_errors_first output;
    layers.(size - 1)#update_weights;
    for i = size - 2 downto 0 do
      layers.(i)#calc_error layers.(i + 1)#get_error;
      layers.(i)#update_weights;
    done

  method save path =
    let file = open_out path in
      Marshal.to_channel file self [Marshal.Closures]

end


class layer in_size size f f' rate momentum =
object(self)

  val neurons = Array.init size (fun _ -> new Neuron.t in_size)
  val prods = Array.make size 0.
  val outputs = Array.make size 0.
  val errors = Array.make size 0.
  val mutable input = Array.make in_size 0.

  method get_output = outputs
  method get_error = errors

  method process inp =
    input <- inp;
    let aux n i =
      let (p, o) = n#process input in
        outputs.(i) <- o;
        prods.(o) <- p
    in Array.iteri neurons aux 

  method calc_errors_first expected =
    for i = 0 to size - 1 do
      errors.(i) <- (f' prods.(i)) *. ((fob expected.(i)) -. output.(i));
    done

  method calc_errors prev_err =
    for i = 0 to size - 1 do
      errors.(i) <- (f' prods.(i)) *. (prod_err prev_err);
    done

  method prod_err err =
    for i = 0 to size - 1 do
      let (prod,_) = neurons.(i)#process err in
        errors.(i) <- (f' prods.(i)) *. prod;
    done

  method update_weights =
    for i = 0 to size - 1 do
      neuron.(i)#update_weights rate momentum errors.(i) input
    done

  initializer
    weights#map (fun _ -> (Random.float 2.) -. 1.)

end


let from_file path =
  let file = open_in path in
  let res = Marshal.from_channel file in
    close_in file;
    res
