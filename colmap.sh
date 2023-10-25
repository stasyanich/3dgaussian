#!/usr/bin/env bash

WORKSPACE_DIR=/workspace
GAUSSIAN_DIR=/gaussian-splatting
WORK_DIR=/home/colmapped
VIDEO_DIR="${WORKSPACE_DIR}"/media
PREP_FRAMES_DIR="${WORK_DIR}"/prepared-frames
STATISTIC_FILE="${PREP_FRAMES_DIR}"/statistic.txt
PREP_FRAMES_INPUT_DIR=${PREP_FRAMES_DIR}/input
FILE_EXTENSION="${EXTENSION:-colmapzip}"
#count frames from 1 second
SHOTS="${ENV_FRAME_TO_SEC:-8}" # default 8 frames

VIDEO_FILE_NAME="${VIDEO_FILE:-$(echo $RANDOM | md5sum | head -c 20; echo;)}"

mkdir -p "${PREP_FRAMES_INPUT_DIR}"/

#copy *.{png,jpeg,jpg} to "${PREP_FRAMES_INPUT_DIR}"/
find /workspace/media -regex '.*\.\(jpg\|png\|jpeg\)$' -exec cp {} "${PREP_FRAMES_INPUT_DIR}"/ \;

cd "${VIDEO_DIR}"/ || exit 1
for file in *.{mp4,m4a,mov,avi}; \
do ffmpeg -i "$file" -qscale:v 1 -qmin 1 -vf fps="${SHOTS}" "${PREP_FRAMES_INPUT_DIR}"/"$file"_%04d.jpg; break; \
done

# if "${PREP_FRAMES_DIR}"/input use EMPTY exit
if [ -z "$(ls -A ${PREP_FRAMES_INPUT_DIR})" ]; then
    echo error: "${VIDEO_DIR}" doesnt have any valid media files
    exit 1
fi

RESULT_FILE="${VIDEO_FILE_NAME}"."${FILE_EXTENSION}"
echo RESULT_FILE > "${STATISTIC_FILE}"
echo "${VIDEO_FILE_NAME}"_"${SHOTS}"_frames > "${STATISTIC_FILE}"
# add count prepared images
time python3 "${GAUSSIAN_DIR}"/convert.py -s "${PREP_FRAMES_DIR}"/

# archive result
time 7z a -tzip "${WORKSPACE_DIR}"/"${RESULT_FILE}" "${PREP_FRAMES_DIR}"/. -xr!input

cat "${STATISTIC_FILE}"
rm -rf "${WORK_DIR:?}"/
echo "it's DONE! see:"
