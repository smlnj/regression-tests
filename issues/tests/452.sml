(* https://github.com/smlnj/smlnj/issues/452 *)

local
  val d1 = Date.date {
          year=2000, month=Date.Jan, day=1, hour=12, minute=30, second=45,
          offset=SOME Time.zeroTime
        }
  val d2 = Date.fromTimeUniv (Date.toTime d1)
in
val result = (Date.toString d1 = Date.toString d2)
end;
