(* https://github.com/smlnj/smlnj/issues/383 *)

val result1 = IntListMap.all (fn _ => true) IntListMap.empty;

val result2 = IntListMap.alli (fn _ => true) IntListMap.empty;
