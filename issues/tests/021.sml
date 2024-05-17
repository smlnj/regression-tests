(* https://github.com/smlnj/smlnj/issues/21 *)

functor MkBad (type 'a bad_poly) =
struct
    type 'a bad_poly = 'a bad_poly
end

structure Bad = MkBad (type 'a bad_poly = unit)

datatype 'a bad_data = Data of 'a Bad.bad_poly * 'a

fun demo bd =
   (Data (bd, 1), Data (bd, true));

