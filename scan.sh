#!/bin/bash
while getopts "f" opt; do
  case $opt in
    f) mode='fast' ;;
    *) exit 1 ;;
  esac
done
shift $((OPTIND - 1))

dir=${1:-.}
pushd $dir > /dev/null

find . -type f -print0 | while IFS= read -r -d '' path; do
  case $mode in
    fast)
      size=$(ls -nl "$path" | awk '{print $5}')
      metadata="NULL $size $path"
      ;;
    *)
      metadata=`cksum $path`
      ;;
  esac

  read -r sum size rest <<< "$metadata"
  echo "$path,$size,$sum"
done

popd > /dev/null
