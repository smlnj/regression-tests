(* https://github.com/smlnj/smlnj/issues/445 *)

(* should be `SOME 0` *)
val result = StringCvt.scanString (IntInf.scan StringCvt.BIN) "0x3";
