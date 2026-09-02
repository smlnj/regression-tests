(* https://github.com/smlnj/smlnj/issues/405 *)

val result1 = Real.rem (Real.posInf, 2.0);      (* should be nan *)
val result2 = Real.rem (1.0, 0.0);              (* should be nan *)
val result3 = Real.rem (2.0, Real.posInf);      (* should be 2.0 *)
