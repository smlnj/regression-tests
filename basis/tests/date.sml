(* test/date.sml
   PS 1995-03-20, 1995-05-12, 1996-07-05
*)

local

  structure D = Date
  structure T = Time

  infix 1 seq
  fun e1 seq e2 = e2;
  fun check b = if b then "OK" else "WRONG";
  fun check' f = (if f () then "OK" else "WRONG") handle _ => "EXN";

  fun range (from, to) p =
      let open Int
      in
          (from > to) orelse (p from) andalso (range (from+1, to) p)
      end;

  fun checkrange bounds = check o range bounds;

  val baseTime = T.fromSeconds 1179938250
      (* an arbitrary reference time to use instead of
       * now() to provide consistent output. Have to find
       * another way to test T.now *)
  fun date h =
      D.toString(D.fromTimeLocal(T.+(baseTime, T.fromReal (3600.0 * real h)))) ^ "\n";
  val baseDate = D.fromTimeLocal(baseTime);
  fun mkdate(y,mo,d,h,mi,s) =
       D.date{year=y, month=mo, day=d, hour=h, minute=mi, second=s, offset=NONE}
  fun cmp(dt1, dt2) = D.compare(mkdate dt1, mkdate dt2)

  fun fromto dt =
      D.toString (Option.valOf(D.fromString (D.toString dt))) = D.toString dt

  fun tofrom s =
      D.toString (Option.valOf(D.fromString s)) = s

in

val _ =
    (print "This is now:                    "; print (date 0);
     print "This is an hour from now:       "; print (date 1);
     print "This is a day from now:         "; print (date 24);
     print "This is a week from now:        "; print (date 168);
     print "This is 120 days from now:      "; print (date (24 * 120));
     print "This is 160 days from now:      "; print (date (24 * 160));
     print "This is 200 days from now:      "; print (date (24 * 200));
     print "This is 240 days from now:      "; print (date (24 * 240));
     print "This is the epoch (UTC):        ";
     print (D.toString(D.fromTimeUniv T.zeroTime) ^ "\n");
     print "This is the number of the day:  ";
     print (D.fmt "%j" baseDate ^ "\n");
     print "This is today's weekday:        ";
     print (D.fmt "%A" baseDate ^ "\n");
     print "This is the name of this month: ";
     print (D.fmt "%B" baseDate ^ "\n"));

val test1 =
check'(fn _ =>
               cmp((1993,D.Jul,25,16,12,18), (1994,D.Jun,25,16,12,18)) = LESS
       andalso cmp((1995,D.May,25,16,12,18), (1994,D.Jun,25,16,12,18)) = GREATER
       andalso cmp((1994,D.May,26,16,12,18), (1994,D.Jun,25,16,12,18)) = LESS
       andalso cmp((1994,D.Jul,24,16,12,18), (1994,D.Jun,25,16,12,18)) = GREATER
       andalso cmp((1994,D.Jun,24,17,12,18), (1994,D.Jun,25,16,12,18)) = LESS
       andalso cmp((1994,D.Jun,26,15,12,18), (1994,D.Jun,25,16,12,18)) = GREATER
       andalso cmp((1994,D.Jun,25,15,13,18), (1994,D.Jun,25,16,12,18)) = LESS
       andalso cmp((1994,D.Jun,25,17,11,18), (1994,D.Jun,25,16,12,18)) = GREATER
       andalso cmp((1994,D.Jun,25,16,11,19), (1994,D.Jun,25,16,12,18)) = LESS
       andalso cmp((1994,D.Jun,25,16,13,17), (1994,D.Jun,25,16,12,18)) = GREATER
       andalso cmp((1994,D.Jun,25,16,12,17), (1994,D.Jun,25,16,12,18)) = LESS
       andalso cmp((1994,D.Jun,25,16,12,19), (1994,D.Jun,25,16,12,18)) = GREATER
       andalso cmp((1994,D.Jun,25,16,12,18), (1994,D.Jun,25,16,12,18)) = EQUAL);

val test2 =
    check'(fn _ =>
	   D.fmt "%A" (mkdate(1995,D.May,22,4,0,1)) = "Monday");

val test3 =
    check'(fn _ =>
	   List.all fromto
	   [mkdate(1995,D.Aug,22,4,0,1),
	    mkdate(1996,D.Apr,5,0,7,21),
	    mkdate(1996,D.Mar,5,6,13,58)]);

val test4 =
    check'(fn _ =>
	   List.all tofrom
	   ["Fri Jul 05 14:25:16 1996",
	   "Mon Feb 05 04:25:16 1996",
	   "Sat Jan 06 04:25:16 1996"])

val test5 = (* after bug1416 *)
    check'(fn _ =>
             D.fmt("%j %U %W %%") baseDate = "143 20 21 %");

val test6 = let
      val t = T.fromSeconds 1000000000
      fun tt d = T.toSeconds (D.toTime d)
      in
        check'(fn _ => tt (D.fromTimeUniv t) = 1000000000
          andalso tt (D.fromTimeLocal t) = 1000000000)
      end

val test7 = let
      fun mk (y,m,dd,h,mi,s,off) = D.date{
            year=y, month=m, day=dd,
            hour=h,minute=mi,second=s,
            offset=off
          }
      val i2s = Int.toString
      fun d2s d = concat[
            i2s (D.year d), "-",
            i2s(1 + (case D.month d
               of D.Jan=>0|D.Feb=>1|D.Mar=>2|D.Apr=>3|D.May=>4|D.Jun=>5
                | D.Jul=>6|D.Aug=>7|D.Sep=>8|D.Oct=>9|D.Nov=>10|D.Dec=>11)),
            "-", i2s(D.day d), " ", i2s(D.hour d), ":", i2s(D.minute d), ":",
            i2s(D.second d), " off=",
            case D.offset d
             of NONE => "NONE"
              | SOME t => LargeInt.toString(T.toSeconds t)
          ]
      in
        check' (fn _ =>
          d2s (mk (2000,D.Jan,2,0,0,0,SOME(T.fromSeconds (25*3600))))
            = "2000-1-3 0:0:0 off=3600"
          andalso d2s (mk (2000,D.Jan,2,0,0,0,SOME (T.fromSeconds (~25*3600))))
            = "2000-1-1 0:0:0 off=~3600")
      end

end
