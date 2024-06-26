(* test/textio.sml
   PS 1995-11-22, 1996-04-18
*)


local

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

  open TextIO

  fun fileSize s =
      let val is = openIn s
      in size (inputAll is) before closeIn is end;

  fun dup 0 s = s
    | dup n s = dup (n-1) (s^s)

  val longstring = dup 16 "abcdefg"

  fun checkEmpty(is: instream) : bool =
      not(isSome(inputLine is))

  fun checkLine(is: instream, s: string) : bool =
      case inputLine is
        of SOME s1 => s = s1
         | NONE => false

  (* setting up some test files *)
  val empty  = openOut "data/empty.txt";
  val small  = openOut "data/small1.txt";
  val medium = openOut "data/medium.txt";
  val text   = openOut "data/text.txt";

in

val test1 =
    check'(fn _ =>
	   (closeOut empty;
	    fileSize "data/empty.txt" = 0
	    andalso fileSize "data/empty.txt" = 0));

val test2 =
    check'(fn _ =>
	   (output1(small, #"+");
	    closeOut small;
	    fileSize "data/small1.txt" = 1
	    andalso fileSize "data/small1.txt" = 1));

val test3 =
    check'(fn _ =>
	   let val small = openOut "data/small2.txt"
	   in
	       output(small, "*");
	       closeOut small;
	       fileSize "data/small2.txt" = 1 andalso fileSize "data/small2.txt" = 1
	   end);

val test4 =
    check'(fn _ =>
	   (output(medium, longstring);
	    closeOut medium;
	    fileSize "data/medium.txt" = size longstring
	    andalso fileSize "data/medium.txt" = size longstring))

val test5 =
    check'(fn _ =>
	   let val small = openAppend "data/small2.txt"
	   in
	       output(small, "1");
	       closeOut small;
	       fileSize "data/small2.txt" = 2 andalso fileSize "data/small2.txt" = 2
	   end);

val test6 =
    check'(fn _ =>
	   (output(text, "Line 1\n");
	    output(text, "Line 2\n");
	    output(text, "Line 3");
	    closeOut text;
	    fileSize "data/text.txt" = 20 andalso fileSize "data/text.txt" = 20));

(* Test that stdErr is flushed immediately, that flushOut works, and
 * that print flushes stdOut.  Assumes that stdOut is *not* flushed
 * immediately: *)

val _ =
    let fun stdo s = output(stdOut, s)
	fun stde s = output(stdErr, s)
    in
	print "Two lines of output follow:\n";
	stdo "3"; stde "1"; stdo "4"; stde "2";
	flushOut stdOut;
	stde "  <--- this should read 1234\n";
	stdo "2"; stde "1"; print "3"; stde "4"; stdo "5";
	flushOut stdOut;
	stde " <--- this should read 12345\n"
    end;

val test7a =
    check'(fn _ =>
	   let val is = openIn "data/empty.txt"
	   in
	       (endOfStream is
		andalso input1 is = NONE
		andalso endOfStream is
		andalso input1 is = NONE)
	       before closeIn is
	   end);

val test7b =
    check'(fn _ =>
	   let val is = openIn "data/small1.txt"
	   in
	       (not (endOfStream is)
		andalso input1 is = SOME #"+"
		andalso endOfStream is
		andalso input1 is = NONE
		andalso input1 is = NONE)
	       before closeIn is
	   end);

val test7c =
    check'(fn _ =>
	   let val is = openIn "data/small2.txt"
	   in
	       (not (endOfStream is)
		andalso input1 is = SOME #"*"
		andalso not (endOfStream is)
		andalso input1 is = SOME #"1"
		andalso endOfStream is
		andalso input1 is = NONE
		andalso input1 is = NONE)
	       before closeIn is
	   end);

val test8a =
    check'(fn _ =>
	   let val is = openIn "data/empty.txt"
	   in
	       (inputN(is, 0) = ""
		andalso inputN(is, 1) = ""
		andalso inputN(is, 100) = ""
		andalso endOfStream is)
	       before closeIn is
	   end);

val test8b =
    check'(fn _ =>
	   let val is = openIn "data/small1.txt"
	   in
	       (inputN(is, 0) = ""
		andalso inputN(is, 1) = "+"
		andalso inputN(is, 100) = "")
	       before closeIn is
	   end);

val test8c =
    check'(fn _ =>
	   let val is = openIn "data/small1.txt"
	   in
	       (inputN(is, 0) = ""
		andalso inputN(is, 100) = "+"
		andalso inputN(is, 100) = "")
	       before closeIn is
	   end);

val test8d =
    check'(fn _ =>
	   let val is = openIn "data/small2.txt"
	   in
	       (inputN(is, 0) = ""
		andalso inputN(is, 1) = "*"
		andalso inputN(is, 100) = "1"
		andalso inputN(is, 100) = "")
	       before closeIn is
	   end);

val test8e =
    check'(fn _ =>
	   let val is = openIn "data/medium.txt"
	   in
	       (inputN(is, 0) = ""
		andalso inputN(is, 15) = "abcdefgabcdefga"
		andalso inputN(is, 15) = "bcdefgabcdefgab"
		andalso inputN(is, 0) = ""
		andalso not (endOfStream is))
	       before closeIn is
	   end);

val test8f =
    check'(fn _ =>
	   let val is = openIn "data/medium.txt"
	   in
	       (inputN(is, 500000) = longstring
		andalso inputN(is, 100) = ""
		andalso endOfStream is)
	       before closeIn is
	   end);

val test9a =
    check'(fn _ =>
	   let val is = openIn "data/empty.txt"
	   in
	       (lookahead is = NONE
		andalso input is = ""
		andalso lookahead is = NONE
		andalso input is = "")
	       before closeIn is
	   end);

val test9b =
    check'(fn _ =>
	   let val is = openIn "data/small1.txt"
	   in
	       (lookahead is = SOME #"+"
		andalso input is = "+"
		andalso input is = ""
		andalso lookahead is = NONE)
	       before closeIn is
	   end);

val test9c =
    check'(fn _ =>
	   let val is = openIn "data/small2.txt"
	   in
	       (lookahead is = SOME #"*"
		andalso input is = "*1"
		andalso input is = ""
		andalso lookahead is = NONE)
	       before closeIn is
	   end);

val test9d =
    check'(fn _ =>
	   let val is = openIn "data/small2.txt"
	   in
	       (input is = "*1"
		andalso input is = "")
	       before closeIn is
	   end);

val test9e =
    check'(fn _ =>
	   let val is = openIn "data/medium.txt"
	   in
	       lookahead is = SOME #"a"
	       andalso String.substring(input is, 0, 15) = "abcdefgabcdefga"
	       before closeIn is
	   end);

val test10 =
    check'(fn _ =>
	   let val is = openIn "data/medium.txt"
	   in
	       (lookahead is = SOME #"a"
		andalso input1 is = SOME #"a"
		andalso lookahead is = SOME #"b"
		andalso input1 is = SOME #"b"
		andalso lookahead is = SOME #"c")
	       before closeIn is
	   end);

val test11 =
    check'(fn _ =>
	   let val is = openIn "data/medium.txt"
	   in
	       (lookahead is = SOME #"a"
		andalso inputN(is, 5) = "abcde"
		andalso lookahead is = SOME #"f"
		andalso inputN(is, 4) = "fgab"
		andalso lookahead is = SOME #"c")
	       before closeIn is
	   end);

val test12a =
    check'(fn _ =>
	   let val is = openIn "data/empty.txt"
	   in
	       (checkEmpty is andalso
                checkEmpty is)
	       before closeIn is
	   end);

val test12b =
    check'(fn _ =>
	   let val is = openIn "data/small1.txt"
	   in
	       (checkLine(is, "+\n") andalso
                checkEmpty is)
	       before closeIn is
	   end);

val test12c =
    check'(fn _ =>
	   let val is = openIn "data/text.txt"
	   in
	       (checkLine(is, "Line 1\n") andalso
	        checkLine(is, "Line 2\n") andalso
                checkLine(is, "Line 3\n") andalso
                checkEmpty is)
	       before closeIn is
	   end);

val test12d =
    check'(fn _ =>
	   let val is = openIn "data/medium.txt"
	   in
	       (checkLine(is, longstring ^ "\n")
	       andalso checkEmpty is)
	       before closeIn is
	   end);

(* Test that outputSubstr works *)

val _ =
    let fun stdo s i n = outputSubstr(stdOut, Substring.substring(s, i, n))
	fun stde s = output(stdErr, s)
	val abcde = "abcde"
    in
	print "Two lines of output follow:\n";
	stdo abcde 0 1; stdo abcde 1 3;
	stdo "" 0 0; stdo abcde 0 0; stdo abcde 5 0; stdo abcde 3 0;
	stdo abcde 4 1;
	flushOut stdOut;
	stde " <--- this should read abcde\n";
	stdo abcde 0 5;
	flushOut stdOut;
	stde " <--- this should read abcde\n"
    end;

end
