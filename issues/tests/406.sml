(* https://github.com/smlnj/smlnj/issues/406 *)

val (a, b) = let
      val SOME(a, rest) = CharVectorSlice.getVec (CharVectorSlice.slice ("abcdefg", 0, SOME 2), 2);
      in
        (a, CharVectorSlice.vector rest)
      end;
