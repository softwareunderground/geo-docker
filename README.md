# geo-docker
A docker image fully loaded with Geo* & ML related packages.

 1. clone this repo into a folder *alongside* other repos or folders with code you want to execute in
 1. build and launch a container with python notebook attached with `make notebook`.
 1. In the notebook, browse to the `/workspace` folder, you should see the contents of your the parent directory mounted as a volume, which means read/write access from the container.
 1. A folder `~/Datasets` is also mounted in the container at `/data`

To change any of the mounted paths, or add more edit the Makefile

At the moment, the configuration has first class setup for keras, as that is where it started out.

## What's in the Box
A full Anaconda install is huge and we are adding to that with common ml and geo packages. To try and stop this getting too bloated we have stuck with a MiniConda base image, meaning we need to be exoplicit about what we add but we only get what we want.

Some attept has been made to have sections in the `Dockerfile` in the hope that it's easier for people to customise to their needs.

The container currently holds:
 - loads of packages
 - that probably should be listed
 - somewhere, maybe here
 - .....

## Missing stuff
Here is a list of packages that were not included initially, maybe these should be turned into issues! :)
 - GPRMax package
 - noddy executable for pynoddy
 - torch & pytorch
 - pygimli
 - fatiando
 - cupy - slow to install
 - devito

There are some other things it would be nice to do too:

 - add a dead simple example notebook athe at least exercises the GPU via tensorflow, maybe even jsut an xor, or minst example or something.
 - setup tensorboard properly with jupyter-tensorflow and provide an example of how to use it

## Installing Docker

General installation instructions are
[on the Docker site](https://docs.docker.com/installation/), but we give some
quick links here:

* [OSX](https://docs.docker.com/installation/mac/): [docker toolbox](https://www.docker.com/toolbox)
* [ubuntu](https://docs.docker.com/installation/ubuntulinux/)

## Running the container

We are using `Makefile` to simplify docker commands within make commands.

Build the container and start a Jupyter Notebook

    $ make notebook

Build the container and start an iPython shell

    $ make ipython

Build the container and start a bash

    $ make bash

For GPU support install NVIDIA drivers (ideally latest) and
[nvidia-docker](https://github.com/NVIDIA/nvidia-docker). Run using

    $ make notebook GPU=0 # or [ipython, bash]

Switch keras between Theano and TensorFlow

    $ make notebook BACKEND=theano
    $ make notebook BACKEND=tensorflow

Mount a volume for external data sets

    $ make DATA=~/mydata

Prints all make tasks

    $ make help

You can change Theano parameters by editing `/docker/theanorc`.

Note: If you would have a problem running nvidia-docker you may try the old way
we have used. But it is not recommended. If you find a bug in the nvidia-docker report
it there please and try using the nvidia-docker as described above.

    $ export CUDA_SO=$(\ls /usr/lib/x86_64-linux-gnu/libcuda.* | xargs -I{} echo '-v {}:{}')
    $ export DEVICES=$(\ls /dev/nvidia* | xargs -I{} echo '--device {}:{}')
    $ docker run -it -p 8888:8888 $CUDA_SO $DEVICES gcr.io/tensorflow/tensorflow:latest-gpu

# License
?

# Credits
This docker and Makefile layout was originally based on the [docker starter example in the keras repo](https://github.com/keras-team/keras/tree/master/docker). THe Docker file in particular has been customised to make it easier to see groups of related packages and add remove as necessary. But the makefile and instructions in this readme are pretty much as-is and lovely. The original repository available under [MIT here](https://github.com/keras-team/keras/blob/master/LICENSE)