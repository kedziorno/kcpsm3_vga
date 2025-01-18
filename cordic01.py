# Cordic for dummies
# Used to calculate x,y and return normalize numbers based on ITERS constant.

from math import atan2, sqrt, sin, cos, radians, floor, ceil

ITERS = 15
norm = pow(2,ITERS)
norm_tt = pow(2,ITERS-7)
PI = 3.14159265
RANGE_L = -PI/2
RANGE_R = PI/2
RANGE_STEP = 1
K_N = 0.60725294

theta_table = [floor(((atan2(1,2**i))*180/PI)*norm_tt) for i in range (ITERS)]
#theta_table = [ceil(((atan2(1,2**i))*180/PI)*norm_tt) for i in range (ITERS)]

def CORDIC(angle):
    x = ceil(K_N*norm)
    y = 0
    desiredangle = 0
    if angle > 90*norm:
      desiredangle = 180*norm
    if angle > 270*norm:
      desiredangle = 360*norm
    #for i in range(ITERS-1,0,-1):
    for i in range(ITERS):
      arc_tangent = theta_table[i]
      if desiredangle > angle:
        #print(f"t < a, P2i = {P2i}")
        y1 = (y >> i)
        #print(f"y>>P2i = {y1:+.8f}")
        x = x - y1
        #print(f"x=x-y1 = {x:+.8f}")
        x1 = (x >> i)
        #print(f"x>>P2i = {x1:+.8f}")
        y = y + x1
        #print(f"y=y+x1 = {y:+.8f}")
        #print(f"arc_tan + {ceil(arc_tangent):+.8f}")
        angle = angle + arc_tangent
        #print(f"theta + = {theta:+.8f}")
      else:
        #print(f"t > a, P2i = {P2i}")
        y1 = (y >> i)
        #print(f"y>>P2i = {y1:+.8f}")
        x = x + y1
        #print(f"x=x+y1 = {x:+.8f}")
        x1 = (x >> i)
        #print(f"x>>P2i = {x1:+.8f}")
        y = y - x1
        #print(f"y=y-x1 = {y:+.8f}")
        #print(f"arc_tan - {ceil(arc_tangent):+.8f}")
        angle = angle - arc_tangent
        #print(f"theta - {theta:+.8f}")
      if (desiredangle > 90*norm) and (desiredangle < 270*norm):
        x = -x
        y = -y
      cos = x
      sin = y
    return  cos, sin, cos/norm, sin/norm

if __name__ == "__main__":
    for i in range (ITERS):
      print (f"arc_tg theta = {theta_table[i]:+.8f}")
    for angle in range (-90,91,1):
      cos, sin, cos_norm, sin_norm = CORDIC (angle)
      print (f"angle = {angle:+.1f}\tcos = {cos:+.8f}\tsin = {sin:+.8f}\tcos_n = {cos_norm:+.8f}\tsin_n = {sin_norm:+.8f}") 
    #cos = Dec256 (cos)
    #sin = Dec256 (sin)
    #print (f"cos = {cos:+.8f}, sin = {sin:+.8f}") 
    # Print a table of computed sines and cosines, from RANGE_L° to RANGE_R°, in steps of RANGE_STEP°,
    # comparing against the available math routines.
    #print("\tx\t\tsin(x) normalize\tcos(x) normalize\tsin(x)\t\t\tdiff. sine\t\tcos(x)\t\t\tdiff. cosine ")
    #for x in range(ceil(RANGE_L*(180/PI)), ceil(RANGE_R*(180/PI)+1), ceil(RANGE_STEP)):
    #    x_rad = ceil(radians(x)*iters_pow2)
    #    K_n, cos_x_norm, sin_x_norm, cos_x, sin_x = CORDIC(x_rad, ITERS)
    #    print(
    #        f"{x:+.1f} ang/{x_rad:+.1f} rad\
    #        {sin_x_norm:+.8f}\
    #        {cos_x_norm:+.8f}\
    #        {sin_x:+.8f}\
    #        ({sin_x-sin(radians(x)):+.8f})\
    #        {cos_x:+.8f}\
    #        ({cos_x-cos(radians(x)):+.8f})\
    #        "
    #    )
    #print (f"K_n = {K_n:+.8f} , ITERS = {ITERS} , normalize numbers must be divided (or shifted) by {pow(2,ITERS*2)} ( >> {ITERS*2} )")
    #for arc_tangent in theta_table[:ITERS]:
    #  atg = arc_tangent/iters_pow2
    #  arc_tangent_ceil = floor(arc_tangent)
    #  print(f"arc_tangent = {arc_tangent:+.8f}/(0x{arc_tangent_ceil:02x}) ({atg:+.8f})");

