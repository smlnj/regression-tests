(* https://github.com/smlnj/smlnj/issues/436 *)

local
  fun test () = let
        val {infd, outfd} = Posix.IO.pipe ()
        (* lseek(2) on a pipe fails with ESPIPE *)
        in
          Posix.IO.lseek (infd, 0, Posix.IO.SEEK_SET); "BAD"
        end
          handle e => concat["OK(", exnMessage e, ")\n"];
in
val result = test()
end;
