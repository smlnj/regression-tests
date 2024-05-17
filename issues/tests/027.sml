(* https://github.com/smlnj/smlnj/issues/27 *)

IEEEReal.setRoundingMode IEEEReal.TO_ZERO;

Real.toLargeInt IEEEReal.TO_ZERO 10.0;

