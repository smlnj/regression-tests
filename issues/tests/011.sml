(* https://github.com/smlnj/smlnj/issues/11 *)

let fun split_ST3_SK3_SK1_ST3 (x55, x56, x57, x58, x59) = split_ST2_SK3_SK1_ST3 (op + (x55, 1), x56, x57, x58, x59)
      and yield_SK2_ST3_SK1_ST3 (x50, x51, x52, x53, x54) = split_ST3_SK3_SK1_ST3 (x50, x51, x52, x53, x54)
      and split_ST2_SK2_ST3_SK1 (x46, x47, x48, x49) = if op > (x46, x47) then [] else yield_SK2_ST3_SK1_ST3 (x48, x49, x46, x46, x47)
      and split_ST3_SK2_ST3_SK1 (x42, x43, x44, x45) = split_ST2_SK2_ST3_SK1 (op + (x42, 1), x43, x44, x45)
      and split_ST1_ST3_ST3_SK1 (x38, x39, x40, x41) = split_ST3_SK2_ST3_SK1 (x38, x39, x40, x41)
      and yield_SK1_ST1_ST3_ST3 (x33, x34, x35, x36, x37) = op :: (x33, split_ST1_ST3_ST3_SK1 (x34, x35, x36, x37))
      and yield_SK3_SK1_ST3_ST3 (x27, x28, x29, x30, x31, x32) = yield_SK1_ST1_ST3_ST3 ((x27, x30), x28, x29, x31, x32)
      and split_ST2_SK3_SK1_ST3 (x22, x23, x24, x25, x26) = if op > (x22, x23) then [] else yield_SK3_SK1_ST3_ST3 (x24, x25, x26, x22, x22, x23)
      and split_ST4_SK3_SK1_ST3 (x17, x18, x19, x20, x21) = split_ST2_SK3_SK1_ST3 (x17, x18, x19, x20, x21)
      and yield_SK2_ST4_SK1_ST3 (x12, x13, x14, x15, x16) = split_ST4_SK3_SK1_ST3 (x12, x13, x14, x15, x16)
      and split_ST2_SK2_ST4_SK1 (x8, x9, x10, x11) = if op > (x8, x9) then [] else yield_SK2_ST4_SK1_ST3 (x10, x11, x8, x8, x9)
      and split_ST4_SK2_ST4_SK1 (x4, x5, x6, x7) = split_ST2_SK2_ST4_SK1 (x4, x5, x6, x7)
      and split_ST5_ST4_ST4_SK1 (x0, x1, x2, x3) = split_ST4_SK2_ST4_SK1 (x0, x1, x2, x3)
  in split_ST5_ST4_ST4_SK1 (0, 10, 20, 30)
  end;

