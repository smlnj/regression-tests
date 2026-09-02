(* https://github.com/smlnj/smlnj/issues/404 *)

(* should be "%Y" *)
val result = Date.fmt "%%Y" (Date.fromTimeUniv (Time.fromSeconds 0));
