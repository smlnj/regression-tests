(* https://github.com/smlnj/smlnj/issues/447 *)

local
  val ss = Substring.full "\f\v"
  val s1 = Substring.string (StringCvt.skipWS Substring.getc ss)
  val s2 = Substring.string (StringCvt.dropl Char.isSpace Substring.getc ss)
in
  val result = (s1 = s2)
end;
