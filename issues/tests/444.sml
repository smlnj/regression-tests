(* https://github.com/smlnj/smlnj/issues/444 *)

val result = Int32.abs ~2147483648 handle Overflow => 0;
