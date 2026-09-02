(* https://github.com/smlnj/smlnj/issues/370 *)

CM.autoload "$/sexp-lib.cm";

SExpParser.parse (TextIO.openString "'foo");
