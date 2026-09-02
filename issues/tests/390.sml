(* https://github.com/smlnj/smlnj/issues/390 *)

CM.autoload "$/pp-lib.cm";

val () = let
    val s = TextIOPP.openOut {dst = TextIO.stdOut, wid = 10}
    in
      TextIO.print "\n===\n";
      TextIOPP.openHOVBox s (TextIOPP.Rel 0);
      TextIOPP.string s "aaaaa";
      TextIOPP.break s {nsp = 1, offset = 0};
      TextIOPP.string s "bbbb";
      TextIOPP.closeBox s;
      TextIOPP.closeStream s;
      TextIO.print "\n===\n"
    end;
