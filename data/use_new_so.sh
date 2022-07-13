#!/usr/bin/env bash
#already is root
if [ $# -lt 3 ]; then
  echo "args cnt not match!"
  exit 1
fi

args=("$@")
((arg_cnt_p1=$#-1))


PKG_NAME=$1
MAIN_ACTIVITY=$2


PKG_P="${PKG_NAME}-"
PKG_DIR_NAME=$(ls /data/app/ | grep ${PKG_P})
if [ "${PKG_DIR_NAME}" == "" ]; then
  ALL_DIRS=$(ls /data/app)
  for dir in $ALL_DIRS; do
    sub_dir=$(ls /data/app/${dir})
    if [ "${sub_dir:0:${#PKG_P}}" = ${PKG_P} ]; then
      PKG_DIR_NAME="${dir}/${sub_dir}"
      break
    fi
  done
fi
if [ "${PKG_DIR_NAME}" == "" ]; then
  echo "no PKG_DIR_NAME"
  exit 1
fi

PKG_DIR_FULL_PATH="/data/app/${PKG_DIR_NAME}"
echo "PKG_DIR_FULL_PATH=${PKG_DIR_FULL_PATH}"
am force-stop $PKG_NAME || exit 1
all_arch=$(ls $PKG_DIR_FULL_PATH/lib)
for one_arch in $all_arch; do
  for i in $(seq 2 1 $arg_cnt_p1); do
    NEW_SO_NAME=${args[i]}
    cp /data/local/tmp/${NEW_SO_NAME} ${PKG_DIR_FULL_PATH}/lib/${one_arch}/ || exit 1
    echo done:copy $NEW_SO_NAME to $one_arch
  done
done

am start $PKG_NAME/$MAIN_ACTIVITY || exit 1
echo "all done use_new_so"
