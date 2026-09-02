(* https://github.com/smlnj/smlnj/issues/389 *)

(* should be "BadFormat" *)
val result = (Format.format "%" []) handle ex => General.exnName ex;
