#!/bin/bash

TOOL_PATH="$HOME/tools/"

NUM_JOBS=4
MAX_JOBS=4
export NUM_JOBS MAX_JOBS

BASE_PATH="$HOME/workspace/binutils"
TMP_PATH="$HOME/workspace/tmp"

ARCH_X86="i686-ubuntu-linux-gnu"
ARCH_X8664="x86_64-ubuntu-linux-gnu"
ARCH_ARM="arm-ubuntu-linux-gnueabi"
ARCH_ARM64="aarch64-ubuntu-linux-gnu"
ARCH_MIPS="mipsel-ubuntu-linux-gnu"
ARCH_MIPS64="mips64el-ubuntu-linux-gnu"

OPTIONS=""
EXTRA_CFLAGS=""
EXTRA_LDFLAGS=""

if [ $# -eq 0 ]; then ARCH="x86_64"; else ARCH=$1; fi

if [ $ARCH == "x86_32" ]; then
  ARCH_PREFIX=$ARCH_X86
  OPTIONS="${OPTIONS} -m32"
  ELFTYPE="ELF 32-bit LSB"
  ARCHTYPE="Intel 80386"
elif [ $ARCH == "x86_64" ]; then
  ARCH_PREFIX=$ARCH_X8664
  ELFTYPE="ELF 64-bit LSB"
  ARCHTYPE="x86-64"
elif [ $ARCH == "arm_32" ]; then
  ARCH_PREFIX=$ARCH_ARM
  ELFTYPE="ELF 32-bit LSB"
  ARCHTYPE="ARM, EABI5"
elif [ $ARCH == "arm_64" ]; then
  ARCH_PREFIX=$ARCH_ARM64
  ELFTYPE="ELF 64-bit LSB"
  ARCHTYPE="ARM aarch64"
elif [ $ARCH == "mips_32" ]; then
  ARCH_PREFIX=$ARCH_MIPS
  OPTIONS="${OPTIONS} -mips32r2"
  ELFTYPE="ELF 32-bit LSB"
  ARCHTYPE="MIPS, MIPS32"
elif [ $ARCH == "mips_64" ]; then
  ARCH_PREFIX=$ARCH_MIPS64
  OPTIONS="${OPTIONS} -mips64r2"
  ELFTYPE="ELF 64-bit LSB"
  ARCHTYPE="MIPS, MIPS64"
fi

cd $BASE_PATH
make clean >/dev/null && make distclean >/dev/null

rm -rf $TMP_PATH && mkdir -p $TMP_PATH
rm -rf $BASE_PATH/install && mkdir -p $BASE_PATH/install

COMPVER="8.2.0"
export PATH="${TOOL_PATH}/${ARCH_PREFIX}-${COMPVER}/bin:${PATH}"
SYSROOT="${TOOL_PATH}/${ARCH_PREFIX}-${COMPVER}/${ARCH_PREFIX}/sysroot"
SYSTEM="${TOOL_PATH}/${ARCH_PREFIX}-${COMPVER}/${ARCH_PREFIX}/sysroot/usr/include"

COMPILER_OPT=""
COMPILER_OPT+=" -O2"

##! o0
# COMPILER_OPT+=" -fcombine-stack-adjustments" ##
# COMPILER_OPT+=" -fcompare-elim" ##
# COMPILER_OPT+=" -fdefer-pop" ##
# COMPILER_OPT+=" -fipa-pure-const" ##
# COMPILER_OPT+=" -fomit-frame-pointer" ##
# COMPILER_OPT+=" -fshrink-wrap" ##
# COMPILER_OPT+=" -fsplit-wide-types" ##
# COMPILER_OPT+=" -ftree-coalesce-vars" ##
# COMPILER_OPT+=" -ftree-ter" ##

##! o1
##! working for all
# COMPILER_OPT+=" -falign-functions"
# COMPILER_OPT+=" -falign-jumps"
# COMPILER_OPT+=" -falign-loops"
# COMPILER_OPT+=" -fcaller-saves"
# COMPILER_OPT+=" -fcode-hoisting"
# COMPILER_OPT+=" -fcrossjumping"
# COMPILER_OPT+=" -fcse-follow-jumps"
# COMPILER_OPT+=" -fexpensive-optimizations"
# COMPILER_OPT+=" -fschedule-insns"
# COMPILER_OPT+=" -fschedule-insns2"
# COMPILER_OPT+=" -fgcse"
# COMPILER_OPT+=" -freorder-blocks-algorithm=stc"
# COMPILER_OPT+=" -fipa-ra"
# COMPILER_OPT+=" -foptimize-sibling-calls"
# COMPILER_OPT+=" -foptimize-strlen"
# COMPILER_OPT+=" -ftree-vrp"
# COMPILER_OPT+=" -fpeephole2"

##! done
# COMPILER_OPT+=" -fstore-merging" ##! elfedit
# COMPILER_OPT+=" -fipa-sra" ##! elfedit
# COMPILER_OPT+=" -fisolate-erroneous-paths-dereference" ##! elfedit
# COMPILER_OPT+=" -flra-remat" ##! elfedit

# COMPILER_OPT+=" -ftree-builtin-call-dce" ##! no




CMD=""
CMD="--host=\"${ARCH_PREFIX}\""
CMD="${CMD} CFLAGS=\""
CMD="${CMD} -isysroot ${SYSROOT} -isystem ${SYSTEM} -I${SYSTEM}"
CMD="${CMD} ${COMPILER_OPT}"
CMD="${CMD} ${OPTIONS}\""
CMD="${CMD} LDFLAGS=\"${OPTIONS} ${EXTRA_LDFLAGS}\""
CMD="${CMD} AR=\"${ARCH_PREFIX}-gcc-ar\""
CMD="${CMD} RANLIB=\"${ARCH_PREFIX}-gcc-ranlib\""
CMD="${CMD} NM=\"${ARCH_PREFIX}-gcc-nm\""
CMD="${CMD} --disable-gdb --disable-gdbserver --disable-sim"

CONF="./configure --prefix=\"${BASE_PATH}/install\" --build=x86_64-linux-gnu ${CMD}"
MAKE="make -j 4 -l 4"
INS="make install"

##! configure
echo "[*] CONF: $CONF"
eval $CONF -q >/dev/null

##! make
echo "[*] MAKE: $MAKE"
eval $MAKE >/dev/null

##! make install
echo "[*] INS: $INS"
eval $INS >/dev/null

cp -r $BASE_PATH/install/bin/* $TMP_PATH/

# EOF

