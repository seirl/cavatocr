let (w_char, h_char) = (16, 10)

class neuron (id:int) =
object (self)
  val mutable weights = Matrix.make w_char h_char 0.0
  val mutable count_learn = 0

  method get_id = id
  method get_weight x y = weights.(x).(y)
  method get_count_learn = count_learn

  method rand_weights =
    for i = 0 to w_char - 1 do
      for j = 0 to h_char - 1 do
            weights.(i).(j) <- (Random.float 11.) -. 5.
      done
    done

  method rate x y =
    match count_learn with
      | 0 -> infinity
      | n -> weights.(x).(y) /. (float count_learn)

  method correct mat error =
    for i = 0 to w_char - 1 do
      for j = 0 to h_char - 1 do
        begin
          if mat.(i).(j) = 1 then
            weights.(i).(j) <- weights.(i).(j) +. error
        end
      done
    done;
    count_learn <- count_learn + 1

  method perceptron mat =
    let r = ref 0. in
    for i = 0 to w_char - 1 do
      for j = 0 to h_char - 1 do
          r := !r +. mat.(i).(j) *. weights.(i).(j)
      done
    done;
    !r
end

class network (chars:string) (size:int) =
object (self)
  val mutable neurons = Hashtbl.create size
  initializer
    for a = 0 to (String.length chars) - 1 do
      Hashtbl.add neurons chars.[a] (new neuron a)
    done
end
