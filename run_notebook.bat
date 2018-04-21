set src=E:\Development\euclidity
set data=E:\Data
set backend=tensorflow
docker run -it -p 0.0.0.0:8888:8888 -v %src%:/src/workspace -v %data%:/src/workspace/data --env KERAS_BACKEND=%backend% geoml