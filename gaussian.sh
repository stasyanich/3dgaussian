#!/usr/bin/env bash

getFirstFile() {
  for dir in $1; do
    for file in "$dir"/*."$2"; do
      if [ -f "$file" ]; then
        echo "${file}"
        break 1
      fi
    done
  done
}

WORKSPACE_DIR=/workspace
WORK_DIR=/home/3dgs
GAUSSIAN_DIR=/gaussian-splatting

INPUT_FILE_EXTENSION="${1:-colmapzip}"
OUTPUT_FILE_EXTENSION="${1:-plyzip}"

FILE_NAME_ABSOLUTE_PATH=$(getFirstFile "$WORKSPACE_DIR" "$INPUT_FILE_EXTENSION")
FILE_NAME_EXTENSION="${FILE_NAME_ABSOLUTE_PATH##*/}"  # ${file##*/}" - file name and extension
FILE_NAME="${FILE_NAME_EXTENSION%.*}"

echo "INPUT_FILE_EXTENSION" "${INPUT_FILE_EXTENSION}"
echo FILE_NAME_ABSOLUTE_PATH "${FILE_NAME_ABSOLUTE_PATH}"
echo FILE_NAME_EXTENSION "${FILE_NAME_EXTENSION}"
echo FILE_NAME "${FILE_NAME}"


NAME_DIR_COLMAP="${FILE_NAME}"-colmap
NAME_DIR_PLY="${FILE_NAME}"-ply

#make directories
mkdir -p "${WORK_DIR}"/{"$NAME_DIR_COLMAP","$NAME_DIR_PLY"}

# unzip file
7z x "${FILE_NAME_ABSOLUTE_PATH}" -o"${WORK_DIR}/${NAME_DIR_COLMAP}"
echo "--- extracting is success ---"

# TODO how to catch python errors and stop script
# if script ok, then delete $FILE_NAME_ABSOLUTE_PATH
#----
# run training script
python "${GAUSSIAN_DIR}"/train.py -s "${WORK_DIR}/${NAME_DIR_COLMAP}" -m "${WORK_DIR}/${NAME_DIR_PLY}"

# archive result
time 7z a -tzip "${WORKSPACE_DIR}"/"${FILE_NAME}"."${OUTPUT_FILE_EXTENSION}" "${WORK_DIR}/${NAME_DIR_PLY}"/. -xr!iteration_7000

rm -rf "$WORK_DIR"
echo "--- dir " ${WORK_DIR} " was deleted ---"


