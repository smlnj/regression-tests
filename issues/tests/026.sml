(* https://github.com/smlnj/smlnj/issues/26 *)

val () = (
      Signals.setHandler (
        Signals.sigGC,
        Signals.HANDLER(fn (_, _, k) => (print "**** GC ****\n"; k)));
      SMLofNJ.Internals.GC.doGC 100000;
      OS.Process.exit OS.Process.success);
