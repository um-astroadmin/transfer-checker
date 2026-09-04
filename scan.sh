#!/bin/bash
dir=${1:-.}
pushd $dir > /dev/null

find . -type f -print0 | while IFS= read -r -d '' path; do
  metadata=`cksum $path`
  read -r sum size rest <<< "$metadata"
  echo "$path,$size,$sum"
done

popd > /dev/null
