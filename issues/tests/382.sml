(* https://github.com/smlnj/smlnj/issues/382 *)

structure S = HashSetFn(struct
    type hash_key = int
    val sameKey = op =
    val hashVal = Word.fromInt
  end);

val s = S.mkEmpty 0;

val () = (
    S.add (s, 0);
    S.filter (fn _ => false) s);

val result = (List.length(S.listItems s) = S.numItems s);
