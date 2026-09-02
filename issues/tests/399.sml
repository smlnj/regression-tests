(* https://github.com/smlnj/smlnj/issues/399 *)

local
  val t : unit IntHashTable.hash_table = IntHashTable.mkTable (0, Fail "")
  val () = IntHashTable.insert t (1, ())
  val SOME() = IntHashTable.findAndRemove t 1
in
val result = (List.length(IntHashTable.listItems t) = IntHashTable.numItems t)
end;
