(* https://github.com/smlnj/smlnj/issues/380 *)

local
  val m = CharMap.mkCharMap {bindings = [], default = false}
in
val result = CharMap.mapChr m #"\255"
end;
