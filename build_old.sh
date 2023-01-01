#!/bin/bash

BASE_PATH="$HOME/comprov/binutils"
TMP_PATH="$HOME/comprov/tmp"
CONFIG_OPT_DEFAULT="--prefix=$BASE_PATH/install --disable-gdb --disable-gdbserver --disable-sim"

if [ $# -eq 0 ]; then TARGET="x64"; else TARGET=$1; fi

if [ $TARGET = "x64" ]; then
  export CC="/home/topcue/dep/gcc/install/bin/gcc";
  export CXX="/home/topcue/dep/gcc/install/bin/g++";
  CONFIG_OPT=$CONFIG_OPT_DEFAULT""
# elif [ $TARGET = "x86" ]; then
#   export CC="gcc -m32"; export CXX="g++ -m32";
#   CONFIG_OPT=$CONFIG_OPT_DEFAULT""
# elif [ $TARGET = "arm32" ]; then
#   export CC="arm-linux-gnueabi-gcc"; export CXX="arm-linux-gnueabi-g++";
#   CONFIG_OPT=$CONFIG_OPT_DEFAULT" --host=arm-linux-gnueabi"
# elif [ $TARGET = "arm64" ]; then
#   export CC="aarch64-linux-gnu-gcc"; export CXX="aarch64-linux-gnu-g++";
#   CONFIG_OPT=$CONFIG_OPT_DEFAULT" --host=aarch64-linux-gnu"
else
  echo "[-] Unknown target!"
  exit 0
fi

COMPILER_OPT=""
COMPILER_OPT+=" -O0"

##! o1
COMPILER_OPT+=" -fcombine-stack-adjustments" ##
COMPILER_OPT+=" -fcompare-elim" ##
COMPILER_OPT+=" -fdefer-pop" ##
COMPILER_OPT+=" -fipa-pure-const" ##
COMPILER_OPT+=" -fomit-frame-pointer" ##
COMPILER_OPT+=" -fshrink-wrap" ##
COMPILER_OPT+=" -fsplit-wide-types" ##
COMPILER_OPT+=" -ftree-coalesce-vars" ##
COMPILER_OPT+=" -ftree-ter" ##

# COMPILER_OPT+=" -falign-functions"
# COMPILER_OPT+=" -falign-jumps"
# COMPILER_OPT+=" -falign-loops"
# COMPILER_OPT+=" -fcaller-saves"
# COMPILER_OPT+=" -fcode-hoisting"
# COMPILER_OPT+=" -fcrossjumping"
# COMPILER_OPT+=" -fcse-follow-jumps"
# COMPILER_OPT+=" -fexpensive-optimizations"
# COMPILER_OPT+=" -fgcse"
# COMPILER_OPT+=" -fstore-merging"
# COMPILER_OPT+=" -freorder-blocks-algorithm=stc"
# COMPILER_OPT+=" -fipa-ra"
# COMPILER_OPT+=" -fipa-sra"
# COMPILER_OPT+=" -fisolate-erroneous-paths-dereference"
# COMPILER_OPT+=" -flra-remat"
# COMPILER_OPT+=" -foptimize-sibling-calls"
# COMPILER_OPT+=" -foptimize-strlen"
# COMPILER_OPT+=" -fschedule-insns"
# COMPILER_OPT+=" -fschedule-insns2"
# COMPILER_OPT+=" -ftree-builtin-call-dce"
# COMPILER_OPT+=" -ftree-vrp"

## applies only to some binaries (except elfedit)
# COMPILER_OPT+=" -fhoist-adjacent-loads"
# COMPILER_OPT+=" -findirect-inlining"
# COMPILER_OPT+=" -fpeephole2"
# COMPILER_OPT+=" -ftree-tail-merge"
# COMPILER_OPT+=" -freorder-blocks-and-partition"
# COMPILER_OPT+=" -fipa-cp"
# COMPILER_OPT+=" -fipa-icf"
# COMPILER_OPT+=" -fipa-vrp"
# COMPILER_OPT+=" -fpartial-inlining"
# COMPILER_OPT+=" -fsched-interblock"
# COMPILER_OPT+=" -fsched-spec"
# COMPILER_OPT+=" -fstrict-aliasing"
# COMPILER_OPT+=" -ftree-pre"

## applies only to some binaries (objdump, readelf)
# COMPILER_OPT+=" -fipa-bit-cp"
# COMPILER_OPT+=" -freorder-functions"
# COMPILER_OPT+=" -frerun-cse-after-loop"
# COMPILER_OPT+=" -fthread-jumps"

## not working
# COMPILER_OPT+=" -falign-labels"
# COMPILER_OPT+=" -fcse-skip-blocks"
# COMPILER_OPT+=" -fdelete-null-pointer-checks"
# COMPILER_OPT+=" -fdevirtualize"
# COMPILER_OPT+=" -fdevirtualize-speculatively"
# COMPILER_OPT+=" -fgcse-lm"
# COMPILER_OPT+=" -finline-small-functions"
# COMPILER_OPT+=" -ftree-switch-conversion"


echo "[*] build_binar_pair.sh info"
echo "  [*] TARGET:       " $TARGET
echo "  [*] CC:           " $CC
echo "  [*] TMP_PATH:     " $TMP_PATH
echo "  [*] CONFIG_OPT:   " $CONFIG_OPT
echo "  [*] COMPILER_OPT: " $COMPILER_OPT

rm -rf $TMP_PATH && mkdir -p $TMP_PATH
rm -rf $BASE_PATH/build && mkdir -p $BASE_PATH/build
rm -rf $BASE_PATH/install && mkdir -p $BASE_PATH/install
cd $BASE_PATH/build && CFLAGS=$COMPILER_OPT $BASE_PATH/configure $CONFIG_OPT -q # 2>/dev/null
echo "[*] make"
cd $BASE_PATH/build && make -j 4 >/dev/null # 2>&1
cd $BASE_PATH/build && make install >/dev/null
cp -r $BASE_PATH/install/bin/* $TMP_PATH

# EOF

