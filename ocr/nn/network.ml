class neuron(length, i_id) =
object (self)
  val id:int = i_id
  val mutable weights = Matrix.make length length 0.0
  val mutable count_learn = 0

  method get_id = id
  method get_weight x y = weights.(x).(y)
  method get_count_learn = count_learn

  method rate x y =
    match count_learn with
      | 0 -> infinity
      | n -> weights.(x).(y) /. (float count_learn)

  method learn mat =
    for i = 0 to length - 1 do
      for j = 0 to length - 1 do
        begin
          if mat.(i).(j) = 1 then
            (weights.(i).(j) <- (weights.(i).(j) +. 1.0))
        end
      done
    done
    nb_learned <- nb_learned + 1
end
