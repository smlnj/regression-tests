(* https://github.com/smlnj/smlnj/issues/373 *)

CM.autoload "$/json-lib.cm";

JSONParser.parse (JSONParser.openString "03");
