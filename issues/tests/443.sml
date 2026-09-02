(* https://github.com/smlnj/smlnj/issues/443 *)

val result = (case StringCvt.scanString NetHostDB.scan "999.999.999.999"
       of NONE => "OK"
        | SOME _ => "BAD"
      (* end case *)) handle _ => "BAD";

