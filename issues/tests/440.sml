(* https://github.com/smlnj/smlnj/issues/440 *)

local
  val parser = ParserComb.skipBefore Char.isSpace (ParserComb.result true)
in
val result1 = StringCvt.scanString parser ""
val result2 = StringCvt.scanString parser " "
end;
