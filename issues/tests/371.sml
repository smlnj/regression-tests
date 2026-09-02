(* https://github.com/smlnj/smlnj/issues/371 *)

CM.autoload "$/sexp-lib.cm";

SExpParser.parse (TextIO.openString "-3.14");
