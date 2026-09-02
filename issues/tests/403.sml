(* https://github.com/smlnj/smlnj/issues/403 *)

(* should be `true` *)
val result = Substring.isSubstring "" (Substring.full "");
