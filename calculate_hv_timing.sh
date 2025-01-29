#!/bin/bash

# http://www.tinyvga.com/vga-timing/640x480@60Hz
#

#Screen refresh rate	60 Hz
#Vertical refresh	31.46875 kHz
#Pixel freq.	25.175 MHz
#Horizontal timing (line)
#Polarity of horizontal sync pulse is negative.

#Scanline part	Pixels	Time [µs]
#Visible area	640	25.422045680238
#Front porch	16	0.63555114200596
#Sync pulse	96	3.8133068520357
#Back porch	48	1.9066534260179
#Whole line	800	31.777557100298
#Vertical timing (frame)
#Polarity of vertical sync pulse is negative.

#Frame part	Lines	Time [ms]
#Visible area	480	15.253227408143
#Front porch	10	0.31777557100298
#Sync pulse	2	0.063555114200596
#Back porch	33	1.0486593843098
#Whole frame	525	16.683217477656

hva=25.422045680238;
hfp=0.63555114200596;
hsp=3.8133068520357;
hbp=1.9066534260179;
hwl=31.777557100298;

vva=15.253227408143;
vfp=0.31777557100298;
vsp=0.063555114200596;
vbp=1.0486593843098;
vwf=16.683217477656;

start_absolute=0;
scale=1000;
step=3;
clock_period=10;
cpi=2;
cpi_step=$(( cpi * step * clock_period ));
#cpi_step=1;

h_va=`echo "(($hva - $start_absolute) * $scale) / $cpi_step" | bc`;
echo $h_va
h_fp=`echo "(($hfp - $start_absolute) * $scale) / $cpi_step" | bc`;
echo $h_fp
h_sp=`echo "(($hsp - $start_absolute) * $scale) / $cpi_step" | bc`;
echo $h_sp
h_bp=`echo "(($hbp - $start_absolute) * $scale) / $cpi_step" | bc`;
echo $h_bp
h_wl=`echo "(($hwl - $start_absolute) * $scale) / $cpi_step" | bc`;
echo $h_wl

v_va=`echo "(($vva - $start_absolute) * $scale * $scale) / $h_wl" | bc`;
echo $v_va
v_fp=`echo "(($vfp - $start_absolute) * $scale * $scale) / $h_wl" | bc`;
echo $v_fp
v_sp=`echo "(($vsp - $start_absolute) * $scale * $scale) / $h_wl" | bc`;
echo $v_sp
v_bp=`echo "(($vbp - $start_absolute) * $scale * $scale) / $h_wl" | bc`;
echo $v_bp
v_wf=`echo "(($vwf - $start_absolute) * $scale * $scale) / $h_wl" | bc`;
echo $v_wf

function f () {
  name=$1;
  value=$2;
  scale=$3;
  printf "; %s\n" $value;
  mod_lo=`echo "$value % $scale" | bc`;
  mod_lo_hex=`echo "obase=16;$value % $scale" | bc`;
  if [ $mod_lo -lt 16 ]; then
    printf "CONSTANT %s_LO, 0%s;\n" $name $mod_lo_hex ;
  else
    printf "CONSTANT %s_LO, %s;\n" $name $mod_lo_hex ;
  fi;
  mod_hi=`echo "$value / $scale" | bc`;
  mod_hi_hex=`echo "obase=16;$value / $scale" | bc`;
  if [ $mod_hi -lt 16 ]; then
    printf "CONSTANT %s_HI, 0%s;\n" $name $mod_hi_hex ;
  else
    printf "CONSTANT %s_HI, %s;\n" $name $mod_hi_hex ;
  fi;
}


#set -x
f "C_H_VA" $(( $h_va )) 256
f "C_H_FP" $(( $h_va+$h_fp )) 256
f "C_H_SP" $(( $h_va+$h_fp+$h_sp )) 256
f "C_H_BP" $(( $h_va+$h_fp+$h_sp+$h_bp )) 256
f "C_H_WL" $(( $h_va+$h_fp+$h_sp+$h_bp+$h_wl )) 256

f "C_V_VA" $v_va 256
f "C_V_FP" $v_fp 256
f "C_V_SP" $v_sp 256
f "C_V_BP" $v_bp 256
f "C_V_WF" $v_wf 256

