help:
	@cat Makefile

DATA?="${HOME}/Datasets"
GPU?=0
DOCKER_FILE=Dockerfile
DOCKER=GPU=$(GPU) nvidia-docker
BACKEND=tensorflow
PYTHON_VERSION?=3.6
CUDA_VERSION?=9.0
CUDNN_VERSION?=7
TEST=tests/
SRC?=$(shell dirname `pwd`)

build:
	docker build -t geoml --build-arg python_version=$(PYTHON_VERSION) -f $(DOCKER_FILE) . 

bash: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/src/workspace/data --env KERAS_BACKEND=$(BACKEND) geoml bash

ipython: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/src/workspace/data --env KERAS_BACKEND=$(BACKEND) geoml ipython

notebook: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/src/workspace/data --net=host --env KERAS_BACKEND=$(BACKEND) geoml

test: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/src/workspace/data --env KERAS_BACKEND=$(BACKEND) geoml py.test $(TEST)

