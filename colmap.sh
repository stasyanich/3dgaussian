#!/usr/bin/env bash

VIDEO_FILE_NAME=""

#count frames from 1 second
SHOTS="${ENV_FRAME_TO_SEC:-8}" # default 8 frames

VIDEO_FOLDER=/workspace/video
MAIN_DIR=/home/gaus/prepared-frames

mkdir -p "${MAIN_DIR}"/input
cd "${VIDEO_FOLDER}"/ || exit 1
for file in *.{mp4,m4a,mov,avi}; \
do VIDEO_FILE_NAME+="$file"_ && ffmpeg -i "$file" -qscale:v 1 -qmin 1 -vf fps="${SHOTS}" "${MAIN_DIR}"/input/"$file"_%04d.jpg; \
done

RESULT_FILE="${VIDEO_FILE_NAME}"_"${SHOTS}"_fr.colmapzip

time python3 /gaussian-splatting/convert.py -s "${MAIN_DIR}"/
time 7z a -tzip /workspace/"${RESULT_FILE}" "${MAIN_DIR}"/. -xr!input

rm -rf /home/gaus/
echo "it's DONE! see:" "${RESULT_FILE}"