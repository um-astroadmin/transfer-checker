#!/bin/bash
while getopts "n" opt; do
  case $opt in
    n) out='names' ;;
    *) exit 1 ;;
  esac
done
shift $((OPTIND - 1))

dir=${1:-.}
pushd $dir > /dev/null

missing=()
badsize=()
badsum=()

while IFS=',' read -r path size sum || [ -n "$path" ]; do
  if [ -r $path ]; then
    case $sum in
      NULL) # If the checksum is NULL, then run in "fast mode"
        lsize=$(ls -nl "$path" | awk '{print $5}')
        metadata="NULL $lsize $path"
        ;;
      *)
        metadata=`cksum $path`
    esac

    read -r lsum lsize rest <<< "$metadata"
    if [ "$size" -ne "$lsize" ]; then
      badsize+=("$path")
    elif [[ "$sum" != "NULL" && "$sum" -ne "$lsum" ]]; then
      badsum+=("$path")
    fi
  else
    missing+=("$path")
  fi
done

case $out in
  names)
    echo "${missing[@]} ${badsize[@]} ${badsum[@]}"
    ;;
  *)
    if [ ${#missing[@]} -ne 0 ]; then
      echo "Missing: ${missing[@]}"
    fi
    if [ ${#badsize[@]} -ne 0 ]; then
      echo "Bad Size: ${badsize[@]}"
    fi
    if [ ${#badsum[@]} -ne 0 ]; then
      echo "Bad Sum: ${badsum[@]}"
    fi
esac

popd > /dev/null
