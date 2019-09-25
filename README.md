# DeepRacer-Anaconda-QuickStart
Setup your environment fast and easy with advanced access to all goodies from crr0004 DeepRacer repository.

**This repository is based on awesome work of our great DeepRacer League community [guru](https://github.com/crr0004).**

For help and more details about elements of DeepRacer local installation [refer to our guru repository](https://github.com/crr0004/deepracer).

**Warning:** This repository is an adaptation of my way of using guru's DeepRacer repository. It is not plug and play like other fantastic repos (it is meant to be a source of information). It is a start for using guru's repo and building more on it.

## Why Anaconda?
It is a powerful tool that allows you to have multiple different installation of Python environments including required libraries. It is convenient and helps keep your system tidy.

## What do you need?
- Linux based host (this repo was tested on Ubuntu 18.04 LTS)
- Python 3, Anaconda
- [Minio](https://min.io/download#/linux)
- Preferably a GPU (I won't cover setup for AMD graphics cards)
- git obviously

**NOTE** Cloning this repo is not required. It contains only my scripts to run some common commands.

## Let's begin
### NVIDIA GPU setup
Get nvidia drivers (using ppa is better but slightly more advanced). Reboot. Run `nvidia-smi` in terminal to verify installation.

### Getting it all set - First Steps
- [Anaconda](https://docs.anaconda.com/anaconda/install/linux/)
- [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [Docker-compose](https://docs.docker.com/compose/install/#install-compose)
- **[Docker group created](https://docs.docker.com/install/linux/linux-postinstall/)**
- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0))

I am not going to go through installation process of those again. If you need a summary or help in these first steps [refer to this](https://github.com/ARCC-RACE/deepracer-for-dummies).

## Say hello to Anaconda
Once you got everything working you need to create an conda environment which will hold Python installtion with required packages.

To do this use this command `conda create -n awsdr -c fragcolor -c conda-forge urllib3==1.24.3 botocore==1.12.224 boto3 pyyaml==3.13 awscli cudnn cuda10.0 tensorflow-gpu==1.12 pandas`.

**NOTE** The `awsdr` can be replaced with any name of choice. If you have CUDA installed outside anaconda you should use this command instead:

`conda create -n awsdr -c conda-forge urllib3==1.24.3 botocore==1.12.224 boto3 pyyaml==3.13 awscli tensorflow-gpu==1.12 pandas`. 

Specified versions are necessary because `awscli` tends to generate conflicts of version mismatch.

## Use Anaconda
Before you proceed you have to enable your new environment.

Enabling environment: `source activate awsdr`

Alternatively: `conda activate awsdr` but this may require `conda init` first

Disabling environment: `conda deactivate`

## Getting guru's repo
I should walk through this here but I have added a new directory, which needs explanation.

`git clone --recurse-submodules https://github.com/crr0004/deepracer.git`

Once downloaded some changes should be made:

- rl_coach/rl_deepracer_robomaker.py :

- - `instance_type = 'local_gpu'` or `'local'` - this changes whether nvidia-docker or docker should be used

- - `image_name="crr0004/sagemaker-rl-tensorflow:nvidia"` or `""crr0004/sagemaker-rl-tensorflow:console"` - this changes whether GPU or CPU will be used

- - `hyperparameters={...}` - this should be changed to your liking

- guru's repo root:

- - `mkdir -p robo/container` - used to store SageMaker image temporary files

- - `mkdir -p ~/.sagemaker && cp config.yaml ~/.sagemaker` - get configuration for sagemaker

- - `mkdir robo/job` - my extra directory used to store logs from RoboMaker

## Firing it up
First step is to install sagemaker in our environment. To do this activate environment and type this command inside deepracer folder (guru's repo):

`pip install -U sagemaker-python-sdk/`

If pip complains about wrong version of some package then rerun this command and it will install with no errors.
This error is caused by default packages installed by conda to any new environment. It will break jupyter probably which is not needed in this environment anyway.

You may also want to configure awscli using this command: `aws configure`.

### Minio startup
`minio server ANY_PATH_OF_YOUR_CHOICE`

### SageMaker startup
`(cd rl_coach; python -s rl_deepracer_coach_robomaker.py)`

**It is important to use `python -s` here because we want to use only packages from conda environment.** Common issue not using `-s` attribute is broken jupyter in the entire OS, due to old jsonschema version.

### RoboMaker startup
`docker run --rm --name dr --env-file ./robomaker.env --network sagemaker-local -p 8080:5900 -v $(pwd)/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src:/app/robomaker-deepracer/simulation_ws/src -v $(pwd)/robo/job:/root/.ros/ -it crr0004/deepracer_robomaker:console "./run.sh build distributed_training.launch"`

## Stop it! It is out of control!
No it is not. You can stop training at any time you want. Anyway I recommend to reduce `NUMBER_OF_EPISODES` in `robomaker.env` to some reasonable value like 2000. This prevents from using all your drive space and from crashing system because of that.

Stop sequence: 1) RoboMaker, 2) SageMaker, 3) Minio (ctrl-C).

You need to use docker to correctly stop training.

`docker ps -a` will list your containers.

`docker stop [id of robomaker container] [id of sagemaker container]` you need to provide only first couple of letters of Id.

`docker rm [id of sagemaker container]` RoboMaker was started with autoremove attribute, but SageMaker was started from Python file without autoremove.

## CMD
This folder contains bash script files that do most of that work.

Expected folder hierarchy:

```
deepracer/
---CMD/
---... (all other crr0004 files)
models/
---Model-1 (example)
---Model-2 (example)
```

`s3server.sh` can be run with modified path.

### Automatic scripts
These scripts allow to clean run training, stop and save training, update training model to local S3 bucket.

Get [minio client](https://docs.min.io/docs/minio-client-complete-guide). I recommend binary file for this `cd /usr/bin; sudo wget https://dl.min.io/client/mc/release/linux-amd64/mc && sudo chmod 755 mc`.

Minio client needs to know localhost access keys, so run this to add local minio as host:

`mc host add s3local http://127.0.0.1:9000 minio miniokey`

Example usage:

```
cd path/deepracer/CMD
./autoupdate.sh ExistingModelName
./autorun.sh
./autostop.sh NewModelName
```
