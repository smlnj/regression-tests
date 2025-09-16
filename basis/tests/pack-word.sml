(* pack-word.sml
 *
 * COPYRIGHT (c) 2025 The Fellowship of SML/NJ (https://smlnj.org)
 * All rights reserved.
 *
 * Test word packing structures
 *)

local
  val v1 = Word8Vector.fromList[0w1, 0w2, 0w3, 0w4, 0w5, 0w6, 0w7, 0w8]
  val v2 = Word8Vector.fromList[0w1, 0w2, 0w3, 0w4, 0w0, 0w0, 0w0, 0w0]
  val v3 = Word8Vector.fromList[0w0, 0w0, 0w0, 0w0, 0w1, 0w2, 0w3, 0w4]
  val a1 = Word8Array.fromList[0w1, 0w2, 0w3, 0w4, 0w5, 0w6, 0w7, 0w8]
  fun testPackArr updateFn (w, i) = let
        val arr = Word8Array.array(8, 0w0)
        in
          updateFn (arr, i, w); Word8Array.toVector arr
        end
  fun check b = if b then "OK" else "WRONG";
in
(* 32-bit little-endian tests *)
  val test32l_1 = check(PackWord32Little.subVec(v1, 0) = 0wx04030201)
  val test32l_2 = check(PackWord32Little.subArr(a1, 0) = 0wx04030201)
  val test32l_3 = check(testPackArr PackWord32Little.update (0wx04030201, 0) = v2)
  val test32l_4 = check(testPackArr PackWord32Little.update (0wx04030201, 1) = v3)

(* 32-bit big-endian tests *)
  val test32b_1 = check(PackWord32Big.subVec(v1, 0) = 0wx01020304)
  val test32b_2 = check(PackWord32Big.subArr(a1, 0) = 0wx01020304)
  val test32b_3 = check(testPackArr PackWord32Big.update (0wx01020304, 0) = v2)
  val test32b_4 = check(testPackArr PackWord32Big.update (0wx01020304, 1) = v3)

(* 64-bit little-endian tests *)
  val test64l_1 = check(PackWord64Little.subVec(v1, 0) = 0wx0807060504030201)
  val test64l_2 = check(PackWord64Little.subArr(a1, 0) = 0wx0807060504030201)
  val test64l_3 = check(testPackArr PackWord64Little.update (0wx0807060504030201, 0) = v1)

(* 64-bit big-endian tests *)
  val test64b_1 = check(PackWord64Big.subVec(v1, 0) = 0wx0102030405060708)
  val test64b_2 = check(PackWord64Big.subArr(a1, 0) = 0wx0102030405060708)
  val test64b_3 = check(testPackArr PackWord64Big.update (0wx0102030405060708, 0) = v1)
end
