(* https://github.com/smlnj/legacy/issues/347 *)

datatype 'a nested =
    Nest of 'a * 'a list nested
  | Epsilon

fun sumListWith f lst = let
      fun go ([], acc) = acc
        | go (x :: xs, acc) = go (xs, f x + acc)
      in
        go (lst, 0)
      end

fun go (_ : 'a -> int, Epsilon : 'a nested, acc : int) : int = acc
  | go (f, Nest (x, xs), acc) = let
      val go' : ('a list -> int) * 'a list nested * int -> int = Unsafe.cast go
      in
        go' (sumListWith f, xs, f x + acc)
      end

fun sum n = go (fn x => x, n, 0)

val nested : int nested = Nest (1, Nest ([2, 3, 4], Nest ([[5, 6], [7], [8, 9]], Epsilon)))

val nestedSum = sum nested;

