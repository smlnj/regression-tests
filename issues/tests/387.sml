(* https://github.com/smlnj/smlnj/issues/387 *)

CM.autoload "$/controls-lib.cm";

val ctl = Controls.genControl {
	name="verbose", pri=[0], obscurity=0, help="test flag", default=false
      }
val () = Controls.set(ctl, true)         (* simulate an env-var/config init *)
val opt = Controls.mkOptionFlag {ctl=ctl, short="v", long=NONE};
val result1 = Controls.get ctl;
val _ = GetOpt.getOpt {
      argOrder = GetOpt.RequireOrder,
      options = [opt],
      errFn = fn _ => ()
    } ["-v"];
val result2 = Controls.get ctl;

