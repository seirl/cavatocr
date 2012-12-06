let _ = Random.self_init ()

class neuron size (f: float -> float) =
object(self)
  val weights = Array.init size (fun _ -> (Random.float 2.) -. 1.)
  val mutable prev_err = 0.

  (* Two-in-one method : returns (Aggregation, Activation) results *)
  method process input =
    let prod = ref 0. in
      for i = 0 to size - 1 do
        prod := !prod +. input.(i) *. weights.(i);
      done;
      (!prod, f !prod)

  (* Update the weights *)
  method new_weights rate momentum error input =
    for i = 0 to size - 1 do
      weights.(i) <- weights.(i) +. (rate *. error *. input.(i))
                                 +. (momentum *. prev_err);
    done
end
