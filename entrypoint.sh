#!/usr/bin/env bash

echo  "---start"

echo  "---nvidia_entrypoint success"
if [[ $S_RUNNER = "COLMAP" ]]; then
  . ../colmap.sh
elif [[ $S_RUNNER = "GAUSSIAN" ]]; then
 . ../gaussian.sh
 else
  . ../full.sh
fi

