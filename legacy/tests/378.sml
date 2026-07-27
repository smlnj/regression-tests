(* https://github.com/smlnj/legacy/issues/378 *)

(* Something that allocates a string *)
fun churn () = Int.toString 1

(* Something that calls ML_CStringList *)
fun once () = ignore (Posix.ProcEnv.environ ())

fun loop 0 = ()
  | loop n = (ignore (churn ()); once (); loop (n - 1))

val _ = loop 20000
val _ = print "completed without crashing\n"
val _ = OS.Process.exit OS.Process.success
