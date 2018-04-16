# set out our GPU lib versions
# note even though we only specify the major version for cuDNN it will always pull
ENV CUDA_VERSION 9.0
ENV CUDNN_VERSION 7.0.5.15
FROM nvidia/cuda:${CUDA_VERSION}-devel

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      g++ \
      git \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      wget && \
    rm -rf /var/lib/apt/lists/*

# Install correct CuDNN version for tensorflow
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"
RUN apt-get update && apt-get install -y --no-install-recommends \ 
        libcudnn7=$CUDNN_VERSION-1+cuda9.0 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda9.0 && \
    rm -rf /var/lib/apt/lists/*

# Install conda
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN wget --quiet --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-4.4.10-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-4.4.10-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.4.10-Linux-x86_64.sh && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh

# Install Goodies
ENV NB_USER geo
ENV NB_UID 1000

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chown $NB_USER $CONDA_DIR -R && \
    mkdir -p /src && \
    chown $NB_USER /src

USER $NB_USER

ARG python_version=3.6

RUN conda update -n base conda
RUN conda install -y python=${python_version}
RUN pip install --upgrade pip
RUN pip install https://cntk.ai/PythonWheel/GPU/cntk-2.1-cp36-cp36m-linux_x86_64.whl
RUN pip install --no-cache-dir Cython

## Base Python Packages
RUN conda install \
    bcolz \
    h5py \
    matplotlib \
    mkl \
    nose \
    notebook \
    pygpu \
    pyyaml \
    six

RUN pip install \
    python-dotenv

## Data Science
RUN conda install \
    numpy \
    scipy \
    pandas \
    tqdm \
    colorcet \
    seaborn \
    networkx

## Image Processing
RUN conda install \
    Pillow \
    scikit-image

## ML Packages
RUN conda install \
    scikit-learn \
    six \
    theano

RUN pip install \
    sklearn_pandas \
    tensorflow-gpu \
    tensorboardX \
    jupyter-tensorboard \
    livelossplot

# keras
RUN git clone git://github.com/keras-team/keras.git /src && pip install -e /src[tests] && \
    pip install git+git://github.com/keras-team/keras.git

## Geo Packages
RUN conda install \
    geopandas \
    shapely \
    dask

RUN pip install \
    obspy \
    pynoddy \
    gempy \
    segyio \
    bruges \
    welly \
    fiona \
    rasterio \
    simpeg \
    lasio \
    mplstereonet

## Package install over

RUN conda clean -yt

ADD theanorc /home/$NB_USER/.theanorc

ENV PYTHONPATH='/src/:$PYTHONPATH'

WORKDIR /src

EXPOSE 8888

CMD jupyter notebook --port=8888 --ip=0.0.0.0
