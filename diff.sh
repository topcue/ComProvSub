#!/bin/bash

BASE_PATH=$HOME/ComProv
PATH_A=$BASE_PATH/$1
PATH_B=$BASE_PATH/$2

if [ $# -eq 2 ]; then
  for file in `find $PATH_A/ -type f -printf '%P\n'`; do
    # echo $file
    hashA=`md5sum $PATH_A/$file | awk '{print $1}'`
    hashB=`md5sum $PATH_B/$file | awk '{print $1}'`
    echo "[*] $file"
    if test $hashA != $hashB; then
      echo "    <>"
    else
      echo "    =="
    fi
  done
fi

# EOF

