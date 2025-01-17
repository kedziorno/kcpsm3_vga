# From Wikipedia
# Used to calculate x,y and return normalize numbers based on ITERS constant.

from math import atan2, sqrt, sin, cos, radians, floor, ceil

ITERS = 5
iters_pow2 = pow(2,ITERS)-1
PI = 3.1415
RANGE_L = -PI/2
RANGE_R = PI/2
RANGE_STEP = 15

theta_table = [atan2(1, 2**i)*iters_pow2 for i in range(ITERS)]

def compute_K(n):
    """
    Compute K(n) for n = ITERS. This could also be
    stored as an explicit constant if ITERS above is fixed.
    """
    k = 1.0
    for i in range(n):
        k *= 1 / sqrt(1 + 2 ** (-2 * i))
    return k

def CORDIC(alpha, n):
    assert n <= ITERS
    K_n = compute_K(n)*iters_pow2
    print(f"K_n = {K_n:+.8f}")
    theta = 0
    x = iters_pow2
    print(f"x = {x:+.8f}")
    y = 0
    P2i = 0
    alpha_norm = alpha
    print(f"alpha_norm = {alpha_norm:+.8f}")
    for arc_tangent in theta_table[:n]:
      if theta < alpha_norm:
        print(f"t < a, P2i = {P2i}")
        y1 = (y >> P2i)
        print(f"y>>P2i = {y1:+.8f}")
        x = x - y1
        print(f"x=x-y1 = {x:+.8f}")
        x1 = (x >> P2i)
        print(f"x>>P2i = {x1:+.8f}")
        y = y + x1
        print(f"y=y+x1 = {y:+.8f}")
        print(f"arc_tan + {ceil(arc_tangent):+.8f}")
        theta = theta + ceil(arc_tangent)
        print(f"theta + = {theta:+.8f}")
      else:
        print(f"t > a, P2i = {P2i}")
        y1 = (y >> P2i)
        print(f"y>>P2i = {y1:+.8f}")
        x = x + y1
        print(f"x=x+y1 = {x:+.8f}")
        x1 = (x >> P2i)
        print(f"x>>P2i = {x1:+.8f}")
        y = y - x1
        print(f"y=y-x1 = {y:+.8f}")
        print(f"arc_tan - {ceil(arc_tangent):+.8f}")
        theta = theta - ceil(arc_tangent)
        print(f"theta - {theta:+.8f}")
      P2i += 1
    return  K_n,                                \
            x * K_n,                            \
            y * K_n,                            \
            x/iters_pow2 * K_n/iters_pow2,  \
            y/iters_pow2 * K_n/iters_pow2

if __name__ == "__main__":
    # Print a table of computed sines and cosines, from RANGE_L° to RANGE_R°, in steps of RANGE_STEP°,
    # comparing against the available math routines.
    print("\tx\t\tsin(x) normalize\tcos(x) normalize\tsin(x)\t\t\tdiff. sine\t\tcos(x)\t\t\tdiff. cosine ")
    for x in range(ceil(RANGE_L*(180/PI)), ceil(RANGE_R*(180/PI)+1), ceil(RANGE_STEP)):
        x_rad = ceil(radians(x)*iters_pow2)
        K_n, cos_x_norm, sin_x_norm, cos_x, sin_x = CORDIC(x_rad, ITERS)
        print(
            f"{x:+.1f} ang/{x_rad:+.1f} rad\
            {sin_x_norm:+.8f}\
            {cos_x_norm:+.8f}\
            {sin_x:+.8f}\
            ({sin_x-sin(radians(x)):+.8f})\
            {cos_x:+.8f}\
            ({cos_x-cos(radians(x)):+.8f})\
            "
        )
    print (f"K_n = {K_n:+.8f} , ITERS = {ITERS} , normalize numbers must be divided (or shifted) by {pow(2,ITERS*2)} ( >> {ITERS*2} )")
    for arc_tangent in theta_table[:ITERS]:
      atg = arc_tangent/iters_pow2
      arc_tangent_ceil = ceil(arc_tangent)
      print(f"arc_tangent = {arc_tangent:+.8f}/({arc_tangent_ceil:+.8f}) ({atg:+.8f})");

