(* https://github.com/smlnj/smlnj/issues/432 *)

val result1 = Hash.string' "abc" = Hash.string' "dbc";

val result2 = (Hash.string' ""; "OK") handle _ => "BAD";
