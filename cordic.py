# From Wikipedia
# Used to calculate x,y and return normalize numbers based on ITERS constant.

from math import atan2, sqrt, sin, cos, radians, floor, ceil

ITERS = 9 #1,2,4,8,16,32,64 - with 9 iterations we have "magic" numbers (angles +/- : 0, 30, 45, 90)
iters_pow2 = pow(2,ITERS)-1
RANGE_L = -90#-PI/2
RANGE_R = 90#PI/2
RANGE_STEP = 15
norm = pow(2,ITERS) #dummies
norm_tt = pow(2,ITERS)
PI = 3.14159265
K_N = 0.60725294

theta_table_norm = [atan2(1, 2**i)*iters_pow2 for i in range(ITERS)]
theta_table_wiki = [atan2(1, 2**i) for i in range(ITERS)]
theta_table_dummies = [int(((atan2(1,2**i))*180/PI)*norm_tt) for i in range (ITERS)]

def compute_K(n):
    """
    Compute K(n) for n = ITERS. This could also be
    stored as an explicit constant if ITERS above is fixed.
    """
    k = 1.0
    for i in range(n):
        k *= 1 / sqrt(1 + 2 ** (-2 * i))
    return k

def CORDIC1(alpha, n): # wiki
    assert n <= ITERS
    K_n = compute_K(n)
    theta = 0.0
    x = 1.0
    y = 0.0
    P2i = 1  # This will be 2**(-i) in the loop below
    for arc_tangent in theta_table_wiki[:n]:
        sigma = +1 if theta < alpha else -1
        theta += sigma * arc_tangent
        x, y = x - sigma * y * P2i, sigma * P2i * x + y
        P2i /= 2
    return  K_n, \
            x * K_n, \
            y * K_n, \
            x/iters_pow2 * K_n/iters_pow2, \
            y/iters_pow2 * K_n/iters_pow2

def CORDIC(alpha, n): # norm
    assert n <= ITERS
    K_n = compute_K(n)*iters_pow2
    #print(f"K_n = {K_n:+.8f}")
    theta = 0
    x = iters_pow2
    xnew = 0
    ynew = 0
    #print(f"x = {x:+.8f}")
    y = 0
    P2i = 0
    alpha_norm = alpha
    #print(f"alpha_norm = {alpha_norm:+.8f}")
    for arc_tangent in theta_table_norm[:n]:
      if theta < alpha_norm:
        #print(f"t < a, P2i = {P2i}")
        y1 = (y >> P2i)
        #print(f"y>>P2i = {y1:+.8f}")
        xnew = x - y1
        #print(f"x=x-y1 = {x:+.8f}")
        x1 = (x >> P2i)
        #print(f"x>>P2i = {x1:+.8f}")
        ynew = y + x1
        #print(f"y=y+x1 = {y:+.8f}")
        #print(f"arc_tan + {ceil(arc_tangent):+.8f}")
        theta = theta + ceil(arc_tangent)
        #print(f"theta + = {theta:+.8f}")
      else:
        #print(f"t > a, P2i = {P2i}")
        y1 = (y >> P2i)
        #print(f"y>>P2i = {y1:+.8f}")
        xnew = x + y1
        #print(f"x=x+y1 = {x:+.8f}")
        x1 = (x >> P2i)
        #print(f"x>>P2i = {x1:+.8f}")
        ynew = y - x1
        #print(f"y=y-x1 = {y:+.8f}")
        #print(f"arc_tan - {ceil(arc_tangent):+.8f}")
        theta = theta - ceil(arc_tangent)
        #print(f"theta - {theta:+.8f}")
      x = xnew
      y = ynew
      P2i += 1
    return  K_n,                                \
            x * K_n,                            \
            y * K_n,                            \
            x/iters_pow2 * K_n/iters_pow2,  \
            y/iters_pow2 * K_n/iters_pow2

def CORDIC2(desiredangle): #dummies
    x = int(K_N*norm)
    y = 0
    x1 = 0
    y1 = 0
    xnew = 0
    ynew = 0
    angle = 0
    desiredangle = desiredangle * norm
    if desiredangle > 90*norm:
      desiredangle = 180*norm
    if desiredangle > 270*norm:
      desiredangle = 360*norm
    #for i in range(ITERS-1,0,-1):
    for i in range(ITERS):
      arc_tangent = theta_table_dummies[i]
      #print (arc_tangent)
      if desiredangle > angle:
        #print(f"t < a, P2i = {P2i}")
        y1 = (y >> i)
        #print(f"y>>P2i = {y1:+.8f}")
        xnew = x - y1
        #print(f"x=x-y1 = {x:+.8f}")
        x1 = (x >> i)
        #print(f"x>>P2i = {x1:+.8f}")
        ynew = y + x1
        #print(f"y=y+x1 = {y:+.8f}")
        #print(f"arc_tan + {arc_tangent:+.8f}")
        angle = angle + arc_tangent
        #print(f"theta + = {angle:+.8f}")
      else:
        #print(f"t > a, P2i = {P2i}")
        y1 = (y >> i)
        #print(f"y>>P2i = {y1:+.8f}")
        xnew = x + y1
        #print(f"x=x+y1 = {x:+.8f}")
        x1 = (x >> i)
        #print(f"x>>P2i = {x1:+.8f}")
        ynew = y - x1
        #print(f"y=y-x1 = {y:+.8f}")
        #print(f"arc_tan - {arc_tangent:+.8f}")
        angle = angle - arc_tangent
        #print(f"theta - {angle:+.8f}")
      x = xnew
      y = ynew
      if (desiredangle > 90*norm) and (desiredangle < 270*norm):
        x = -x
        y = -y
      cos = x
      sin = y
    return  cos, sin, cos/norm, sin/norm

if __name__ == "__main__":
    # Print a table of computed sines and cosines, from RANGE_L° to RANGE_R°, in steps of RANGE_STEP°,
    # comparing against the available math routines.
    #print("\tx\t\tsin(x) normalize\tcos(x) normalize\tsin(x)\t\t\tdiff. sine\t\tcos(x)\t\t\tdiff. cosine ")
    print("x ang/rad\t\t\
        sin_x_norm\t\
        cos_x_norm\t\
        six_x_wiki\t\
        cos_x_wiki\t\
        six_x_dummies\t\
        cos_x_dummies")
    for x in range(RANGE_L, RANGE_R+1, RANGE_STEP):
        x_rad = ceil(radians(x)*iters_pow2)
        K_n, cos_x_norm, sin_x_norm, cos_x, sin_x = CORDIC(x_rad, ITERS) #rad_norm
        K_n, cos_x1, sin_x1, cos_x_norm1, sin_x_norm1 = CORDIC1(radians(x), ITERS) #ang->rad
        cos_x2, sin_x2, cos_x2_norm, sin_x2_norm = CORDIC2(x) #angles
        print(
            f"{x:+.1f} ang/{x_rad:+.1f} rad\
            {sin_x:+.8f}\
            {cos_x:+.8f}\
            {sin_x1:+.8f}\
            {cos_x1:+.8f}\
            {sin_x2_norm:+.8f}\
            {cos_x2_norm:+.8f}")
    print("x ang/rad\t\t\
        sin_x_norm\t\
        cos_x_norm\t\
        six_x_wiki\t\
        cos_x_wiki\t\
        six_x_dummies\t\
        cos_x_dummies")
    #print (f"K_n = {K_n:+.8f} , ITERS = {ITERS} , normalize numbers must be divided (or shifted) by {pow(2,ITERS*2)} ( >> {ITERS*2} )")
    exit (0)
    for arc_tangent in theta_table_wiki[:ITERS]:
      atg = arc_tangent
      arc_tangent_ceil = ceil(arc_tangent)
      print(f"arc_tangent wiki = {arc_tangent:+.8f}/({arc_tangent_ceil:+.8f}) ({atg:+.8f})");
    for arc_tangent in theta_table_norm[:ITERS]:
      atg = arc_tangent/iters_pow2
      arc_tangent_ceil = ceil(arc_tangent)
      print(f"arc_tangent norm = {arc_tangent:+.8f}/({arc_tangent_ceil:+.8f}) ({atg:+.8f})");
    for arc_tangent in theta_table_dummies[:ITERS]:
      atg = arc_tangent/iters_pow2
      arc_tangent_ceil = ceil(arc_tangent)
      print(f"arc_tangent dummies = {arc_tangent:+.8f}/({arc_tangent_ceil:+.8f}) ({atg:+.8f})");

