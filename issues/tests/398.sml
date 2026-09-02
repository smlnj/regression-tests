(* https://github.com/smlnj/smlnj/issues/398 *)

val result = let
      val m : string IntListMap.map = IntListMap.empty
      in
        IntListMap.findAndRemove (m, 0) handle ex => SOME(m, General.exnName ex)
      end;
