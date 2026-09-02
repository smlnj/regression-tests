(* https://github.com/smlnj/smlnj/issues/434 *)

(* should be 1 *)
val result = EditDistance.distance ("ab", "ba");
