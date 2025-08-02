(* https://github.com/smlnj/smlnj/issues/317 *)

signature FOLD_STRUCTS = 
   sig
      type 'a t
      type 'a elt
      val fold: 'a t * 'b * ('a elt * 'b -> 'b) -> 'b
   end
signature FOLD = 
   sig
      include FOLD_STRUCTS
   end
functor Fold (S: FOLD_STRUCTS): FOLD = 
   struct
      open S
   end
structure List =
   struct
      structure F =
         struct
            type 'a t = 'a list
            type 'a elt = 'a
            fun fold (l, b, f) =
               let
                  fun loop (l, b) =
                     case l of
                        [] => b
                      | x :: l => loop (l, f (x, b))
               in loop (l, b)
               end
         end
      structure F = Fold (open F)
      open F
      (* val fold : 'a list * 'b * ('a * 'b -> 'b) -> 'b = fold *)
      fun appendRev (l, l') = fold (l, l', op ::)
      (* val appendRev : 'a list * 'a list -> 'a list = appendRev *)
      fun 'a insert {<= : 'a * 'a -> bool} =
         let
            fun insert (l, x) =
               let
                  fun loop (l, ac) =
                     case l of
                        [] => appendRev (ac, [x])
                      | x' :: l' =>
                           if x <= x'
                              then appendRev (ac, x :: l)
                           else loop (l', x' :: ac)
               in loop (l, [])
               end
         in
            insert
         end
   end
