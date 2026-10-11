(* https://github.com/smlnj/smlnj/issues/405 *)

val result1 = Real.rem (Real.posInf, 2.0);      (* should be nan *)
val result2 = Real.rem (1.0, 0.0);              (* should be nan *)
val result3 = Real.rem (2.0, Real.posInf);      (* should be 2.0 *)

structure ReproUpstream405 =
  struct

    val nan = 0.0 / 0.0

  (* reference: x - n*y with n = trunc(x/y), computed exactly.  Each `r - d`
   * has d <= r < 2d, so Sterbenz's lemma makes the subtraction exact.
   *)
    fun remExact (x, y) = let
	  val ay = Real.abs y
	  fun reduce r = if r < ay
		then r
		else let
		  fun up d = let val d2 = d * 2.0
			in if Real.isFinite d2 andalso d2 <= r then up d2 else d end
		  in
		    reduce (r - up ay)
		  end
	  val r = reduce (Real.abs x)
	  in
	    if x < 0.0 then ~r else r
	  end

    fun str r = if Real.isNan r then "nan" else Real.fmt (StringCvt.GEN(SOME 12)) r

  (* ---- part 1: the spec's own edge cases, all of which 4329bd85 fixed ---- *)
    fun edgeCases () = let
	  val inf = Real.posInf
	  fun row (label, x, y, expect) =
		print (concat [
		    "  ", StringCvt.padRight #" " 26 label,
		    " = ", StringCvt.padRight #" " 14 (str (Real64.rem (x, y))),
		    "  expected ", expect, "\n"
		  ])
	  in
	    print "Basis edge cases (4329bd85 handles all of these correctly):\n";
	    row ("rem(inf, 3.0)",      inf,    3.0,    "nan  [x is an infinity]");
	    row ("rem(3.0, 0.0)",      3.0,    0.0,    "nan  [y is zero]");
	    row ("rem(3.0, inf)",      3.0,    inf,    "3    [y is an infinity]");
	    row ("rem(0.0, 3.0)",      0.0,    3.0,    "0");
	    row ("rem(1e~300, 1e300)", 1e~300, 1e300,  "1e~300  [x/y underflows]")
	  end

  (* ---- part 2: finite x, finite non-zero y, overflowing quotient ---- *)
    fun overflowCases () = let
	  fun check (label, x, y) = let
		val got = Real64.rem (x, y)
		val want = remExact (x, y)
		val finiteArgs = Real.isFinite x andalso Real.isFinite y
			andalso not (Real.==(y, 0.0))
		val ok = Real.==(got, want)
		in
		  print (concat [
		      "  ", StringCvt.padRight #" " 22 label, "\n",
		      "      upstream : ", str got, "\n",
		      "      exact    : ", str want, "\n",
		      "      x, y both finite and y <> 0 : ", Bool.toString finiteArgs, "\n",
		      "      |result| < |y| : ",
		      (if Real.isNan got then "NO (result is NaN)"
		       else Bool.toString (Real.abs got < Real.abs y)), "\n",
		      "      VERDICT: ", (if ok then "ok" else "WRONG -- NaN is not licensed here"), "\n"
		    ])
		end
	  in
	    print "\nFinite arguments whose quotient overflows (still wrong):\n";
	    check ("rem(1e300, 1e~300)", 1e300, 1e~300);
	    check ("rem(1e10, 1e~320)",  1e10,  1e~320)
	  end

  (* ---- part 3: the underlying formula is inexact (older than 4329bd85) ----
   * `y * frac(split(x/y))` rounds twice, where the specified x - n*y is
   * exactly representable.  Out of scope for #405, but it deserves an issue.
   *)
    fun accuracy () = let
	  val seed = ref (0w88172645463325252 : Word64.word)
	  fun next () = let
		val s = !seed
		val s = Word64.xorb(s, Word64.<<(s, 0w13))
		val s = Word64.xorb(s, Word64.>>(s, 0w7))
		val s = Word64.xorb(s, Word64.<<(s, 0w17))
		in
		  seed := s;
		  real (Word64.toIntX (Word64.>>(s, 0w14))) / 65536.0
		end
	  val n = 200000
	  val bad = ref 0
	  val shown = ref 0
	  fun loop i = if i >= n then () else let
		val x = next () and y = next ()
		in
		  if Real.==(y, 0.0) orelse not (Real.isFinite (x/y))
		    then ()
		    else let
		      val got = Real64.rem (x, y)
		      val want = remExact (x, y)
		      in
			if not (Real.==(got, want))
			  then (
			    bad := !bad + 1;
			    if !shown < 2
			      then (
				shown := !shown + 1;
				print (concat [
				    "      x = ", str x, "   y = ", str y, "\n",
				    "        upstream ", Real.fmt (StringCvt.FIX(SOME 6)) got,
				    "   exact ", Real.fmt (StringCvt.FIX(SOME 6)) want, "\n"
				  ]))
			      else ())
			  else ()
		      end;
		  loop (i + 1)
		end
	  in
	    print "\nAccuracy of y * frac(split(x/y)) on finite pairs (pre-existing):\n";
	    loop 0;
	    print (concat [
		"      disagreements with the exact remainder: ",
		Int.toString (!bad), " / ", Int.toString n, "\n"
	      ])
	  end

    fun run () = (edgeCases (); overflowCases (); accuracy ())

    end; (* structure ReproUpstream405 *)

val () = ReproUpstream405.run ()

