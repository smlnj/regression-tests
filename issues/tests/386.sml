(* https://github.com/smlnj/smlnj/issues/386 *)

val a = EditDistance.distance("flaw","lawn");
val b = EditDistance.distance("abcdefgh","a");
val c = EditDistance.distance("a","abcdefgh");
