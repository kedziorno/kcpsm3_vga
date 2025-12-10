#!/bin/bash
# This script use dosbox emulator for compilation PSM to VHD file
# Add to dosbox.conf in section [autoexec] lines as:
#   mount d /path/to/repo
#   d:\
#   compile.bat
# When compile is succesfull, dosbox was be killed and build will be started
# Otherwise (in case syntax error), dosbox remains run with message.
#

rm -rf PROGRAM.VHD
rm -rf top.bit

dosbox &

while [ ! -f PROGRAM.VHD ]; do
sleep 1
echo -n "."
done

sleep 1

. /home/user/.local/Xilinx/14.7/ISE_DS/settings64.sh

if [ -f PROGRAM.VHD ]; then
killall dosbox
./synthesis.sh top
ls -l PROGRAM.VHD
ls -l top.bit
time sudo xc3sprog -v -c saturn -p 0 top.bit
exit 0
else
echo "*** program.vhd not found ***"
exit 1
fi
