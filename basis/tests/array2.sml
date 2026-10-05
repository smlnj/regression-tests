(* array2.sml
 *
 * COPYRIGHT (c) 2026 The Fellowship of SML/NJ (https://smlnj.org)
 * All rights reserved.
 *
 * Tests for the Array2 structure
 *)

local

  infix 1 seq
  fun e1 seq e2 = e2;
  fun check b = if b then "OK" else "WRONG";
  fun check' f = (if f () then "OK" else "WRONG") handle _ => "EXN";

  fun p s = print (String.concat s)
  fun dims a = let
        val (r,c) = Array2.dimensions a
        in
          concat ["(", Int.toString r, ",", Int.toString c, ")"]
        end
  fun res f = (f ()) handle Subscript => "Subscript" | e => "OTHER:" ^ exnName e;
  fun il l = String.concatWithMap "," Int.toString l;

  val a50 = Array2.tabulate Array2.RowMajor (5,0,fn _ => 0) : int Array2.array
  val a05 = Array2.tabulate Array2.RowMajor (0,5,fn _ => 0) : int Array2.array
  val a34 = Array2.tabulate Array2.RowMajor (3,4,fn (i,j) => i*10+j) : int Array2.array

in

(* (1) dimensions of an empty array *)
val () = p [
        "Array2.array(0,5,0) dims             = ",
        dims (Array2.array(0,5,0)),
        "   (expected (0,5))\n"
      ]
val () = p [
        "Array2.array(5,0,0) dims             = ",
        dims (Array2.array(5,0,0)),
        "   (expected (5,0))\n"
      ]
val () = p [
        "Array2.tabulate RM (0,5,f) dims      = ",
        dims (Array2.tabulate Array2.RowMajor (0,5,fn _ => 0)),
        "   (expected (0,5); the sibling is already right)\n"
      ]

(* (2) row/column bounds *)
val () = p [
        "Array2.row(5x0 array, 5)             = ",
        res (fn () => il (Vector.toList (Array2.row (a50, 5)))),
        "   (expected Subscript)\n"
      ]

(* (3) column-major whole-array traversal of an n x 0 array *)
val () = p [
        "Array2.app ColMajor over 5x0         = ",
        let val acc : int list ref = ref []
        in
          Array2.app Array2.ColMajor (fn x => acc := x :: !acc) a50;
          Int.toString (List.length (!acc)) ^ " elements visited"
        end,
        "   (expected 0)\n"
      ]

(* (4) empty regions *)
local
  fun countRegion (order, reg) = let
        val c = ref 0
        in
          Array2.appi order (fn _ => c := !c + 1) reg;
          Int.toString (!c)
        end
in
val () = p [
        "appi RowMajor, region with nrows=0   = ",
        countRegion (Array2.RowMajor, {base=a34,row=1,col=0,nrows=SOME 0,ncols=NONE}),
        "   (expected 0)\n"
      ]
val () = p [
        "appi ColMajor, region with ncols=0   = ",
        countRegion (Array2.ColMajor, {base=a34,row=0,col=1,nrows=NONE,ncols=SOME 0}),
        "   (expected 0)\n"
      ]
val () = p [
        "appi RowMajor over the whole 0x5     = ",
        let val acc : int list ref = ref []
        in
          Array2.appi Array2.RowMajor
            (fn (_,_,x) => acc := x :: !acc)
            {base=a05,row=0,col=0,nrows=NONE,ncols=NONE};
          concat [
              Int.toString (List.length (!acc)), " elements, values = ",
              il (rev (!acc))
            ]
        end,
        "   (expected 0 elements)\n"
      ]
end (* local fun countRegion *)

end; (* local *)
