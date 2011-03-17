# Author - Victor Tseng (palatis@gmail.com)
# see #252987
# Commiter in rion - slepnoga

# CompCache settings...

# load ramzswap kernel module on start?
LOAD_ON_START="yes"

# unload ramzswap kernel module on stop?
UNLOAD_ON_STOP="yes"

# number of device
NUM_DEVICES="1"

# for each /dev/ramzswapN, specify these arguments for rszcontrol
# `man rzscontrol` for more informations.
#RAMZSWAP_OPTS_0="--backing_swap=/path/to/swap.file --memlimit_kb=10240 --disksize_kb=10240"
#RAMZSWAP_OPTS_1="--disksize_kb=20480"
