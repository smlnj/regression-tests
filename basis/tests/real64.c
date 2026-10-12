/// \file real64.c
///
/// \copyright 2026 The Fellowship of SML/NJ (https://smlnj.org)
/// All rights reserved.
///
/// \brief C code for generating the "ground truth" for various 64-bit real operations.
///
/// \author John Reppy
///

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <math.h>

/* bit patterns of some interesting doubles */
#define FP64_NEG_INF            0xfff0000000000000ULL   // negative infinity
#define FP64_MIN                0xffefffffffffffffULL   // largest negative number
#define FP64_NEG_ONE            0xbff0000000000000ULL   // -1
#define FP64_NEG_ZERO           0x8000000000000000ULL   // -0
#define FP64_POS_ZERO           0x0000000000000000ULL   // +0
#define FP64_MIN_POS_SUBNORM    0x0000000000000001ULL   // smallest positive subnormal
#define FP64_MAX_POS_SUBNORM    0x000fffffffffffffULL   // largest positive subnormal
#define FP64_ONE_MINUS_ULP      0x3fefffffffffffffULL   // the largest number less than 1
#define FP64_ONE                0x3ff0000000000000ULL   // 1
#define FP64_ONE_PLUS_ULP       0x3ff0000000000001ULL   // the smallest number greater than 1
#define FP64_MAX                0x7fefffffffffffffULL   // largest positive number
#define FP64_POS_INF            0x7ff0000000000000ULL   // positive infinity
#define FP64_NAN                0x7ff8000000000001ULL   // a NaN

#define FP64_MANT_BITS      (52)
#define FP64_MANT_MASK      ((1ULL << FP64_MANT_BITS) - 1)
#define FP64_MANT_INT_BIT   (1ULL << FP64_MANT_BITS)
#define FP64_UPSCALE        (1ULL << FP64_MANT_BITS)
#define FP64_EXPO_BITS      (11)
#define FP64_EXPO_BIAS      ((1ULL << FP64_EXPO_BITS) - 1)
#define FP64_EXPO_MASK      (FP64_EXPO_BIAS << FP64_MANT_BITS)
#define FP64_NAN_INDEFINITE (0xfff8000000000000ULL) /* machine dependent; x86 */
#define FP64_QNAN_BIT       (0x0008000000000000ULL) /* machine dependent; x86 */


uint64_t dtoui64 (double a)
{
    uint64_t r; memcpy (&r, &a, sizeof r); return r;
}

double ui64tod (uint64_t a)
{
    double r; memcpy (&r, &a, sizeof r); return r;
}

/* print a double as 16 hex digits */
void prBits (FILE *outS, double d)
{
    fprintf (outS, "%016" PRIx64, dtoui64(d));
}

/* an integer-based implementation of `fmod`.  This code is what the SML/NJ
 * implementation was modeled after.
 */
double fmod_int (double a, double b)
{
    double r;
    if (isnan (a) || isnan (b)) {
        r = a + b;
    } else if (isinf (a) || (b == 0.0)) {
        r = ui64tod (FP64_NAN_INDEFINITE);
    } else {
        uint64_t ia = dtoui64 (a);
        uint64_t ib = dtoui64 (b);
        if ((ia << 1) >= (ib << 1)) { // fabs (a) >= fabs (b)
            int ea = (ia & FP64_EXPO_MASK) >> FP64_MANT_BITS;
            int eb = (ib & FP64_EXPO_MASK) >> FP64_MANT_BITS;
            /* normalize source operands */
            if (ea == 0) {
                ia = dtoui64 (a * FP64_UPSCALE);
                ea = ((ia & FP64_EXPO_MASK) >> FP64_MANT_BITS) - FP64_MANT_BITS;
            }
            ia = (ia & FP64_MANT_MASK) | FP64_MANT_INT_BIT;
            if (eb == 0) {
                ib = dtoui64 (b * FP64_UPSCALE);
                eb = ((ib & FP64_EXPO_MASK) >> FP64_MANT_BITS) - FP64_MANT_BITS;
            }
            ib = (ib & FP64_MANT_MASK) | FP64_MANT_INT_BIT;

            /* perform binary longhand division */
            while (ea > eb) {
                if (ia >= ib) {
                    ia -= ib;
                }
                ia <<= 1;
                ea--;
            }
            /* ensure remainder is less than divisor */
            if (ia >= ib) {
                ia -= ib;
            }
            /* generate final result for non-zero remainder */
            if (ia != 0) {
                while (ia < FP64_MANT_INT_BIT) { // normalize remainder
                    ia <<= 1;
                    ea--;
                }
                // combine exponent and significand; denormalize if necessary
                ia = (ea > 0) ?
                    (ia + ((uint64_t)(ea - 1) << FP64_MANT_BITS)) :
                    (ia >> (1 - ea));
            }
            r = copysign (ui64tod (ia), a);
        } else {
            r = a;
        }
    }
    return r;
}

/* a floating-point-based implementation of `fmod`.
 */
double fmod_flt (double a, double b)
{
    double r;
    if (isnan (a) || isnan (b)) {
        r = a + b;
    } else if (isinf (a) || (b == 0.0)) {
        r = ui64tod (FP64_NAN_INDEFINITE);
    } else {
        double fa, fb, dividend, divisor;
        int expo_a, expo_b;
        fa = fabs (a);
        fb = fabs (b);
        if (fa >= fb) {
            dividend = fa;
            /* normalize divisor */
            (void)frexp (fa, &expo_a);
            (void)frexp (fb, &expo_b);
            divisor = ldexp (fb, expo_a - expo_b);
            if (divisor <= 0.5 * dividend) {
                divisor += divisor;
            }
            /* compute quotient one bit at a time */
            while (divisor >= fb) {
                if (dividend >= divisor) {
                    dividend -= divisor;
                }
                divisor *= 0.5;
            }
            /* dividend now represents remainder */
            r = copysign (dividend, a);
        } else {
            r = a;
        }
    }
    return r;
}

void compare_fmod (double x, double y)
{
    printf ("fmod (%g, %g):\n", x, y);
    printf ("  libm: "); prBits(stdout, fmod(x, y)); printf("\n");
    printf ("  fp:   "); prBits(stdout, fmod_flt(x, y)); printf("\n");
    printf ("  int:  "); prBits(stdout, fmod_int(x, y)); printf("\n");
}

void test_nextafter (double x, double y)
{
    double z = nextafter (x, y);
    printf ("nextafter (%g [", x); prBits(stdout, x);
    printf ("], %g): %g [", y, z); prBits(stdout, z);
    printf ("]\n");
}

/***** main *****/

int main ()
{
    compare_fmod (1.0e300, 1.0e-300);
    compare_fmod (1.0e10,  1.0e-320);

    test_nextafter (ui64tod(FP64_NEG_ZERO), ui64tod(FP64_NEG_ONE));
    test_nextafter (ui64tod(FP64_POS_ZERO), ui64tod(FP64_NEG_ONE));
    test_nextafter (ui64tod(FP64_MIN), ui64tod(FP64_NEG_INF));
}
