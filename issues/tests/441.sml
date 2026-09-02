(* https://github.com/smlnj/smlnj/issues/441 *)

val result = (case StringCvt.scanString Time.scan "1."
       of SOME t => Time.toSeconds t
        | NONE => 0
      (* end case *)) handle _ => ~1;

