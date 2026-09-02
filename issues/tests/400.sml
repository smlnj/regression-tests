(* https://github.com/smlnj/smlnj/issues/400 *)

local
  val b = Word8Buffer.new 0;
in
val result1 = (Word8Buffer.sub (b, 0); "BAD") handle Subscript => "OK"
val () = Word8Buffer.add1 (b, 0wx20)
val result2 = Word8Buffer.sub (b, 0)
end;
