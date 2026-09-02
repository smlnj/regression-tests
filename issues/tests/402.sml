(* https://github.com/smlnj/smlnj/issues/402 *)

val result = (Array.tabulate (~1, fn _ => raise Fail "BAD"); "REALLY BAD")
      handle Size => "OK"
           | _ => "BAD";
