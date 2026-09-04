#!/bin/bash
dir=${1:-.}
pushd $dir > /dev/null

missing=()
badsize=()
badsum=()

while IFS=',' read -r path size sum || [ -n "$path" ]; do
  if [ -r $path ]; then
    metadata=`cksum $path`
    read -r lsum lsize rest <<< "$metadata"
    if [ "$size" -ne "$lsize" ]; then
      badsize+=("$path")
    elif [ "$sum" -ne "$lsum" ]; then
      badsum+=("$path")
    fi
  else
    missing+=("$path")
  fi
done

if [ ${#missing[@]} -ne 0 ]; then
  echo "Missing: ${missing[@]}"
fi
if [ ${#badsize[@]} -ne 0 ]; then
  echo "Bad Size: ${badsize[@]}"
fi
if [ ${#badsum[@]} -ne 0 ]; then
  echo "Bad Sum: ${badsum[@]}"
fi

popd > /dev/null
