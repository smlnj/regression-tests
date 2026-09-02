(* https://github.com/smlnj/smlnj/issues/375 *)

CM.autoload "$/unix-lib.cm";

UnixEnv.addToEnv ("KEY=k2", ["KEY=k1"]);
