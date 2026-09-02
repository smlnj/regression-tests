(* https://github.com/smlnj/smlnj/issues/384 *)

local
  structure D =
    struct
      type point = int
      val compare = Int.compare
      val minPt = 0
      val maxPt = 999
      fun pred x = x-1
      fun succ x = x+1
      fun isSucc (a,b) = (a+1=b)
    end
  structure IS = IntervalSetFn(D)
  val s = IS.add(IS.add(IS.add(IS.add(IS.empty, 795), 797), 796), 797)
in

val result1 = String.concatWithMap " "
          (fn (a,b) => concat["[", Int.toString a, ",", Int.toString b, "]"])
          (IS.intervals s)

val result2 = String.concatWithMap "," Int.toString (IS.toList s)

end;
