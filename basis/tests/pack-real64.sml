(* pack-real64.sml
 *
 * COPYRIGHT (c) 2026 The Fellowship of SML/NJ (https://smlnj.org)
 * All rights reserved.
 *)

local
fun p s = (print s; print "\n");
fun hexV v = String.concatWithMap " "
      (fn b => StringCvt.padLeft #"0" 2 (Word8.toString b)) (Word8Vector.toList v);
fun hexA a = String.concatWith " "
      (List.tabulate(Word8Array.length a,
        fn i => StringCvt.padLeft #"0" 2 (Word8.toString (Word8Array.sub(a,i)))));
fun show (lbl, got, expect) =
      p (concat[if got = expect then "ok   " else "FAIL ", lbl, " = ", got,
                if got = expect then "" else concat["   (expected ", expect, ")"]]);
in
(* 1.0 = 0x3FF0000000000000, ~2.5 = 0xC004000000000000 *)
val () = show ("PackReal64Big.toBytes 1.0    ", hexV (PackReal64Big.toBytes 1.0),
               "3F F0 00 00 00 00 00 00");
val () = show ("PackReal64Little.toBytes 1.0 ", hexV (PackReal64Little.toBytes 1.0),
               "00 00 00 00 00 00 F0 3F");
val () = show ("PackReal64Big.toBytes ~2.5   ", hexV (PackReal64Big.toBytes ~2.5),
               "C0 04 00 00 00 00 00 00");
val () = show ("PackReal64Little.toBytes ~2.5", hexV (PackReal64Little.toBytes ~2.5),
               "00 00 00 00 00 00 04 C0");

(* fromBytes on a correctly-formed big-endian / little-endian encoding of 1.0 *)
val beOne = Word8Vector.fromList [0wx3F,0wxF0,0w0,0w0,0w0,0w0,0w0,0w0];
val leOne = Word8Vector.fromList [0w0,0w0,0w0,0w0,0w0,0w0,0wxF0,0wx3F];
val () = show ("PackReal64Big.fromBytes <BE 1.0>   ",
               Real.toString (PackReal64Big.fromBytes beOne), "1");
val () = show ("PackReal64Little.fromBytes <LE 1.0>",
               Real.toString (PackReal64Little.fromBytes leOne), "1");

(* cross-check against PackWord64, which is correct *)
val () = let
      val ra = Word8Array.array(8, 0w0) and wa = Word8Array.array(8, 0w0)
      in
        PackReal64Big.update (ra, 0, 1.0);
        PackWord64Big.update (wa, 0, 0wx3FF0000000000000);
        show ("PackReal64Big.update vs PackWord64Big.update", hexA ra, hexA wa)
      end;
val () = let
      val ra = Word8Array.array(8, 0w0) and wa = Word8Array.array(8, 0w0)
      in
        PackReal64Little.update (ra, 0, 1.0);
        PackWord64Little.update (wa, 0, 0wx3FF0000000000000);
        show ("PackReal64Little.update vs PackWord64Little.update", hexA ra, hexA wa)
      end;

(* self-round-trips still succeed even with the bug -- this is why it hid *)
val () = p ("self round-trip Big:    "
      ^ Real.toString (PackReal64Big.fromBytes (PackReal64Big.toBytes 3.75)));
val () = p ("self round-trip Little: "
      ^ Real.toString (PackReal64Little.fromBytes (PackReal64Little.toBytes 3.75)));

end;

