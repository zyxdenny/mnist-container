# Training MNIST in a container

## Docker

The image is built upon Debian image. You can change to other images if you like, but Alpine Linux is not a valid option, since `pytorch` seems to be not available on this distro.

The working directory inside the container is `/mnist`. Before running `python` or `pip` command, we need to be in a virtual environment we have created inside the `/mnist` folder to separate it from the system-wide `python`.

Finally `main.py` is run with `--dry-run` option, just to test if the script runs without error. You may change the options to any parameters you like.

To build an image based on `Dockerfile`, run
``` sh
docker build -t mnist .
```
To run a container based on the built image, run
```sh
docker run -it mnist
```
`docker-run.out` is the ouput of the `docker run` command, captured from stdout.

We can see from the build of the image that Docker build the image layer by layer. If you only make modifications to the last `CMD ...` command, the previous layers will not be rebuilt, which saves a lot of time.

## Apptainer (Singularity)

Apptainer, formerly named Singularity, is yet another container targeted specifically on HPC. Apptainer containers can be built from Docker images. For example, if we want to run a container based on the mnist image we previously built, we first pull the image from Dockerhub:
```sh
apptainer pull docker://zyxdenny/mnist:latest
```
The image will be retrieved and rendered into a `.svf` file. Note that before rendering, you may want to change the location where Apptainer "assembles" the image by specifying `APPTAINER_TMP`, as the default `/tmp` is not enough for large images (discussed [here](https://hpc-community.unige.ch/t/cant-pull-new-singularity-images/2912)).

Then, run a container using:
```sh
apptainer run mnist_latest.svf
```
This outputs the same result as what we do with Docker.

## Comparison

The first difference is that running Docker containers require root privilege, but running Apptainer containers don't. In cases where we train on a server and don't have root privilege, Apptainer is a better choice.

As Apptainer is designed for HPC, It has many features that Docker doesn't have, such as seamless access to GPUs. For research purposes, Apptainer might be a better choice.
