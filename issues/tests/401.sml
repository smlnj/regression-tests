(* https://github.com/smlnj/smlnj/issues/401 *)

local
  val b = Word8Buffer.new 0
  val () = Word8Buffer.add1 (b, 0wx12)
  val arr = Word8Array.array (1, 0w0)
  val () = Word8Buffer.copy {src = b, dst = arr, di = 0}
in
val result = Word8Array.sub(arr, 0) (* should be 0wx12 *)
end;
