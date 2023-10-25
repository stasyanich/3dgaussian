#!/usr/bin/env bash

/opt/nvidia/nvidia_entrypoint.sh

if [[ S_RUNNER=="COLMAP" ]]; then
  exec colmap.sh
else if [[ S_RUNNER=="GAUSSIAN" ]]; then
 exec gaussian.sh
 else
   exec
fi

