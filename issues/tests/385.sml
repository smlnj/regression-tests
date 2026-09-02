(* https://github.com/smlnj/smlnj/issues/385 *)

local
  structure K1 = struct
      type hash_key=int
      val hashVal = Word.fromInt
      val sameKey : int * int -> bool = op =
    end
  structure K2 = struct
      type hash_key=int
      val hashVal = Word.fromInt
      val sameKey : int * int -> bool = op =
    end
  structure H2 = Hash2TableFn(structure Key1=K1 structure Key2=K2)

  val tbl : int H2.hash_table = H2.mkTable (16, Fail "nf")
  val () = H2.insert tbl (1, 100, 1000)   (* k1=1 <-> k2=100 *)
  val () = H2.insert tbl (1, 200, 2000)   (* same k1=1 (existing), new k2=200 *)
  val r1 = H2.find1 tbl 1
  val r2 = H2.find2 tbl 200
  val n = H2.numItems tbl
in

val result = concat[
        "find1 1 = ", case r1 of SOME v => Int.toString v | NONE => "NONE",
        "; find2 200 = ", case r2 of SOME v => Int.toString v | NONE => "NONE",
        "; numItems = ", Int.toString n, "\n"
      ]

end;
