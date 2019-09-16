# DeepRacer-Anaconda-QuickStart
Setup your environment fast and easy with advanced access to all goodies from crr0004 DeepRacer repository.

**This repository is based on awesome work of our great DeepRacer League community [guru](https://github.com/crr0004).**

For help and more details about elements of DeepRacer local installation [refer to our guru repository](https://github.com/crr0004/deepracer).

**Warning:** this repository is created for advanced users who want to benefit of having everything set inside Anaconda. It is not plug and play like other fantastic repos. It is a start for using guru's repo and building more on it.

## Why Anaconda?
It is a powerful tool that allows you to have multiple different installation of Python environments including required libraries. It is convenient and helps to keep your system tidy.

## What do you need?
- Linux based host (this repo was tested on Ubuntu 18.04 LTS)
- Python 3, Anaconda
- Minio
- Preferably a GPU (I won't cover setup for AMD graphics cards)
- git obviously

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
`git clone --recurse-submodules https://github.com/crr0004/deepracer.git`
Once downloaded some changes should be made:
- rl_coach/rl_deepracer_robomaker.py :
-- `instance_type = 'local_gpu'` or `'local'` - this changes whether nvidia-docker or docker should be used
-- `image_name="crr0004/sagemaker-rl-tensorflow:nvidia"` or `""crr0004/sagemaker-rl-tensorflow:console"` - this changes whether GPU or CPU will be used
-- `hyperparameters={...}` - this should be changed to your liking
- guru's repo root:
-- `mkdir -p robo/container` - used to store SageMaker image temporary files
-- `mkdir robo/job` - used to store logs from RoboMaker
-- `mkdir -p ~/.sagemaker && cp config.yaml ~/.sagemaker` - get configuration for sagemaker

## Firing it up
First step is to install sagemaker in our environment. To do this activate environment and type this command inside deepracer folder (guru's repo):
`pip install -U sagemaker-python-sdk/`

You may also want to configure awscli using this command: `aws configure`.

### SageMaker startup
`(cd rl_coach; python rl_deepracer_coach_robomaker.py)`

### RoboMaker startup
`(cd rl_coach; python rl_deepracer_coach_robomaker.py)`
