let m_size = 24
let m_fsize = float m_size

let to_weight c = (tanh ( float (c - 10) /. 25. ) -. 0.1 ) /. 1.1

let norm mat =
  let w1 = Array.length mat and h1 = Array.length mat.(0)
  and m = Array.make_matrix m_size m_size false in
    let r = max ((float w1) /. m_fsize) ((float h1) /. m_fsize) in
      let w2 = int_of_float ((float w1) /. r)
      and h2 = int_of_float ((float h1) /. r) in
        let rx = (float w1) /. (float w2)
        and ry = (float h1) /. (float h2) in
          for i = 0 to w2 - 1 do
            for j = 0 to h2 - 1 do
              let px = int_of_float (floor ((float (i)) *. rx))
              and py = int_of_float (floor ((float (j)) *. ry)) in
                m.(i).(j) <- mat.(px).(py);
            done;
          done;
          m

class neuron =
  object
  val weights = Array.make_matrix m_size m_size (to_weight 0)
  val counts = Array.make_matrix m_size m_size 0
  val mutable sum_weights = 0.
  method get_count i j : int = counts.(i).(j)
  method get_chance m : float =
    let acc = ref 0. in
      for i = 0 to m_size - 1 do
        for j = 0 to m_size - 1 do
          if m.(i).(j) then
            acc := !acc +. weights.(i).(j);
        done;
      done;
      if !acc = 0. then 0. else !acc /. sum_weights
  method learn m =
    for i = 0 to m_size - 1 do
      for j = 0 to m_size - 1 do
        if m.(i).(j) then
        (
          counts.(i).(j) <- counts.(i).(j) + 5;
          weights.(i).(j) <- to_weight counts.(i).(j);
        )
        else
        (
          counts.(i).(j) <- max 0 (counts.(i).(j) - 1);
          weights.(i).(j) <- to_weight counts.(i).(j);
        )
      done;
    done
  method set_count i j c =
    counts.(i).(j) <- c;
    sum_weights <- sum_weights -. weights.(i).(j);
    weights.(i).(j) <- tanh (float c);
    sum_weights <- sum_weights +. weights.(i).(j)
end

class neuron_end =
  let int_to_char i = Char.chr (i + 33) in
  let get_weight i = (to_weight i) /. 10. +. 0.9 in
  object
  val weights = Array.make 94 (get_weight 0)
  val counts = Array.make 94 0
  method get_count i : int = counts.(i)
  method get_int a : int =
    let max = ref 0. and index = ref 0 in
      for i = 0 to 93 do
        let w = weights.(i) *. a.(i) in
          if w > !max then
          (
            max := w;
            index := i;
          )
      done;
      !index
  method set_count i c =
    counts.(i) <- c;
    weights.(i) <- get_weight c;
  method learn i =
    counts.(i) <- counts.(i) + 5;
    weights.(i) <- get_weight counts.(i)
  method print = for i = 0 to 93 do
    Printf.printf "%c: %f" (int_to_char i) (weights.(i));
    print_newline ();
    done
end

class network =
  let int_to_char i = Char.chr (i + 33)
  and char_to_int c = (Char.code c) - 33
  in
    object
    val neurons = Array.init 94 (fun i -> new neuron )
    val last_neuron = new neuron_end
    method get_neurons : neuron array = neurons
    method get_last_neuron : neuron_end = last_neuron
    method read_char mat : char =
      let a = Array.make 94 0. and m = norm mat in
        for i = 0 to 93 do
          a.(i) <- neurons.(i)#get_chance m;
        done;
        int_to_char (last_neuron#get_int a)
    method from_file f =
      let input = open_in f in
        for i = 0 to 93 do
          let n = neurons.(i) in
            for j = 0 to m_size - 1 do
              for k = 0 to m_size - 1 do
                n#set_count j k (input_byte input);
              done;
            done;
        done;
        let n = last_neuron in
          for i = 0 to 93 do
            n#set_count i (input_byte input);
          done;
      close_in input
    method to_file f =
      let out = open_out f in
        for a = 0 to 93 do
          let n = neurons.(a) in
            for i = 0 to m_size - 1 do
              for j = 0 to m_size - 1 do
                 output_byte out (n#get_count i j);
              done;
            done;
        done;
        for i = 0 to 93 do
          output_byte out (last_neuron#get_count i);
        done;
        close_out out
    method learn mat c =
      let index = char_to_int c and m = norm mat in
        neurons.(index)#learn m;
        last_neuron#learn index
    method print_first_weight =
      last_neuron#print
end
