#!/usr/bin/env bash

# home/stanislav/work/fucks/content/output/d6b9bdfb-7

#stanislav@stanislav-desktop:~$ ~/work/sc_r.sh /home/stanislav/work/fucks/test /home/stanislav/work/fucks/out .zip

#input
#stanislav@stanislav-desktop:~$ ~/work/sc_r.sh /home/stanislav/work/fucks/test
#cameras

getFirstFile() {
  for dir in $1; do
    for file in "$dir"/*"$2"; do
      if [ -f "$file" ]; then
        echo "${file}"
        break 1
      fi
    done
  done
}

if [[ -n "$1" && -n "$2" ]]; then
  echo "--- parameters is ok ---"
 else
   exit 1
fi

pip install -q plyfile \
   https://huggingface.co/camenduru/gaussian-splatting/resolve/main/diff_gaussian_rasterization-0.0.0-cp310-cp310-linux_x86_64.whl \
   https://huggingface.co/camenduru/gaussian-splatting/resolve/main/simple_knn-0.0.0-cp310-cp310-linux_x86_64.whl

mkdir -p /content/3dgs
WORK_DIR=/content/3dgs
GAUSSIAN_SPLATTING_DIR=/content/drive/MyDrive/3dgs/app/gaussian-splatting
DIR_FROM="$1"
FILE_EXTENSION="${3:-.colmapzip}"
DIR_TO="$2"
FILE_NAME_ABSOLUTE_PATH=$(getFirstFile "$DIR_FROM" "$FILE_EXTENSION")
FILE_NAME_EXTENSION="${FILE_NAME_ABSOLUTE_PATH##*/}"  # ${file##*/}" - file name and extension
FILE_NAME="${FILE_NAME_EXTENSION%.*}"

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

# run training script
python "${GAUSSIAN_SPLATTING_DIR}"/train.py -s "${WORK_DIR}/${NAME_DIR_COLMAP}" -m "${WORK_DIR}/${NAME_DIR_PLY}"

# archive result
time 7z a -tzip "${DIR_TO}"/"${FILE_NAME}".plyzip "${WORK_DIR}/${NAME_DIR_PLY}"/. -xr!iteration_7000

rm -rf "$WORK_DIR"
echo "--- dir " ${WORK_DIR} " was deleted ---"


