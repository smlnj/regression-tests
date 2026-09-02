(* https://github.com/smlnj/smlnj/issues/448 *)

val result = (Vector.update (#[], 100, "asdf"); "BAD")
      handle Subscript => "OK";
