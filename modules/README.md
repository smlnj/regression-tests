# Module-System tests

196-217,244-260: tests for uncaught EntityEnv.Unbound exception.

220-243: former hof tests

287-288: bug 1296

297-306: sharing/def-spec conflicts

310-315: test that structure def specs are checked properly

316, 316.1: printing of type components of inferred functor result
            signatures

## Bugs:

26.sml: bogus type path
  In signature printed for B, path ?.B.A.s is bogus (A is a phantom
  component of B)

224.sml: (type printing in error message)
  Type of B.C.A.x printed as ?.B.t (should be B.C.A.t?)
  Type of A.x printed as ?.t (should be A.t?)

229.sml: (type printing in error message)
  Type of c.B.x printed as ?.c.t, should be c.B.t.

257.sml: ? in type paths in error message?  (probably not a bug)

276.sml: sharing spec with rigid type (definitional), not allowed in SML97
   the error message appears correct, although not as clear as
   it might be

277.sml: unmatchable signature
   inconsistent where defs applied to sharing type elements, resulting
   in an unmatchable signature.
   1. Should this be checked?  (Does Defn accept this?)
   2. Printed signature is clearly bogus
   (Leave as bug)

284.sml: rigid sharing not detected
   1. Signature S2 should be rejected (check Defn), because sharing spec
      involves a rigid type t.
   2. S2 as printed by the compiler is clearly bogus.

295.sml: properly fails (rigid type in sharing spec)
   1. Error message is obscure
   2. In printing of SIG1, why is SIG0 not used for signature of S?

296.sml: fails properly elaborating signature S (not a bug)

297.sml: former failure in FLINT (uncaught UNBOUND), ok now

298.sml: former failure (related to 297.sml, bug1445), ok now

299.sml: former failure (related to 297.sml, bug1445), ok now

300.sml: former failure (related to 297.sml, bug1445), ok now

301.sml: former failure (related to 297.sml, bug1445), ok now

302.sml: former failure (related to 297.sml, bug1445), ok now

306.sml: former failure (related to 297.sml, bug1445), ok now
