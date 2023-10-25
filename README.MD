
- variables `S_RUNNER` = {`COLMAP` | `GAUSSIAN`}
- frames variables `ENV_FRAME_TO_SEC` default 8
- `EXTENSION=zip` or default colmap file extension  `.colmapzip`
- finished ply file extension  `.plyzip`

structure for media 
```structure
!---workspace
   |---media (required)
       |---<video 0>
       |---<video 1>
       |---<jpeg 0>
       |---<jpeg 1>
       |---...
```


## build colmap

```bash
docker run -it --rm --gpus all -v /home/user/colmap_dir:/workspace nvidia/cuda:11.7.1-devel-ubuntu22.04
```
put script to:

```bash
cp /home/user/colmap_dir/result /this_dir_repos/
```

## build docker image 

install python3
```bash
sudo apt install python3-pip
```

```bash
docker build -t mosstnslv/gaussian:1.0.0 .
```
## push docker image

```bash
docker push mosstnslv/gaussian:1.0.0
```

## run docker image 

### only COLMAP
run in console with and then remove with default: `ENV_FRAME_TO_SEC=8` and `VIDEO_FILE=$(random)`
```bash
docker run -it --gpus all --rm -e "S_RUNNER=COLMAP" -v /home/user/gaussian:/workspace mosstnslv/gaussian:1.0.0 
```

run background and then remove
```bash
docker run -itd --gpus all --rm -e "S_RUNNER=COLMAP" -v /home/user/gaussian:/workspace mosstnslv/gaussian:1.0.0
```
#### OR

run in console with and then remove and env `ENV_FRAME_TO_SEC=1` and `VIDEO_FILE=bnk`
```bash
docker run -it --gpus all --rm -e "S_RUNNER=COLMAP" -e "ENV_FRAME_TO_SEC=1" -e "VIDEO_FILE=bnk" -v /home/user/gaussian:/workspace mosstnslv/gaussian:1.0.0 
```

---
### only GAUSSIAN
run background and then remove
```bash
docker run -itd --gpus all -rm -e "S_RUNNER=GAUSSIAN" -v /home/user/gaussian:/workspace mosstnslv/gaussian:1.0.0
```
#### OR
run in console with and then remove
```bash
docker run -it --gpus all --rm -e "S_RUNNER=GAUSSIAN" -v /home/user/gaussian:/workspace mosstnslv/gaussian:1.0.0 
```
---
### full process
run in console with and then remove
```bash
docker run -it --gpus all --rm  -v /home/user/gaussian:/workspace mosstnslv/gaussian:1.0.0 
```

