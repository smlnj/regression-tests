(* https://github.com/smlnj/legacy/issues/370 *)

print((Int32.* (~0x80000000, ~1); "FAIL\n") handle Overflow => "OK\n");

