(* https://github.com/smlnj/smlnj/issues/381 *)

local
  val _ = Rand48.srand (0w123)
in
val result = String.concatWithMap "." Int.toString
      (List.tabulate (20, fn _ => Int.mod (Rand48.mrand (), 2)))
end;
