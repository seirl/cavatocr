(** The neural network module *)

(** These constants are the size of a character matrix *)
let (w_char, h_char) = (5, 5)

(** A neuron *)
class neuron =
object (self)
  val weights = Matrix.make w_char h_char 0
  val mutable sigma:int = 0
  method get_weight x y = weights.(x).(y)
  method get_weights = weights

  (** Fill the weights with random values *)
  initializer
    for i = 0 to w_char - 1 do
      for j = 0 to h_char - 1 do
        weights.(i).(j) <- (Random.int 11) - 5
      done
    done;
    sigma <- (Random.int 11) - 5

  (** Aggregation function: compute the total input of the neuron *)
  method inputs mat =
    let r = ref 0 in
      for i = 0 to w_char - 1 do
        for j = 0 to h_char - 1 do
          r := !r + mat.(i).(j) * weights.(i).(j)
        done
      done;
      !r - sigma

  (** Activation function: compute the output of a neuron *)
  method output v =
    Tools.int_of_bool (v > 0)

  (** Shortcut for the neuron output *)
  method eval mat =
    self#output (self#inputs mat)

  (** Compute the new weights of a neuron *)
  method new_weights mat error =
    for i = 0 to w_char - 1 do
      for j = 0 to h_char - 1 do
        begin
          if mat.(i).(j) = 1 then
            weights.(i).(j) <- weights.(i).(j) + error
        end
      done
    done;
    sigma <- sigma - error

  (** Replace a neuron's weights *)
  method fix mat expected =
    let error = expected - (self#eval mat) in
    self#new_weights mat error
end

(** The neural network *)
class network (chars:string) =
object (self)
  val mutable neurons = Hashtbl.create (String.length chars)
  initializer
    for a = 0 to (String.length chars) - 1 do
      Hashtbl.add neurons chars.[a] (new neuron)
    done

  method get_neurons = neurons

  (** Train a neuron with one input *)
  method train_neuron ch mat expected =
    let neuron = Hashtbl.find neurons ch in
      neuron#fix mat expected

  (** Train every neuron of the network with one input *)
  method train_all mat expected_char =
    let iter_train ch neuron =
      self#train_neuron ch mat (Tools.int_of_bool (ch = expected_char))
    in
      Hashtbl.iter iter_train neurons

  (** Recognizes the character in input *)
  method recognize mat =
    let a = ref 0 in
    let found_ch = ref None in
    let m = ref 0 in
    while !a <= (String.length chars) - 1 do
      let ch = chars.[!a] in
      let neuron = Hashtbl.find neurons ch in
      let i = neuron#inputs mat in
        if i > !m then
          begin
            found_ch := Some(ch);
            m := i
          end
    done;
    !found_ch
end

