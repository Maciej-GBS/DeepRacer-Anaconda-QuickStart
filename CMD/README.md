### CMD - Compulsory Magical Directory
This folder contains bash script files that do most of repetetive work.

They can help you maintain backups of your models, store their logs, automatically update parameters, change racetrack or reward with a single line command.

Finally there is a very helpful tool for the most lazy of us: queue.

Be advised, using queue requires experience to correctly setup training so you will not waste hours of training hopelessly. A python script that would try to analyze and pick best models is on my TODO list but I lack time to do it and it will probably never appear here.

**Warning:** Risk is on you. This repo contains bash scripts and can be potientially harmful to your computer (of course I did my best it does not but I give no warranty).

## What do you need?
- [Minio](https://min.io/download#/linux)
- [minio client](https://docs.min.io/docs/minio-client-complete-guide)

I recommend binary file for this `cd /usr/bin; sudo wget https://dl.min.io/client/mc/release/linux-amd64/mc && sudo chmod 755 mc`.

Minio client needs to know localhost access keys, so run this to add local minio as host:

`mc host add s3local http://127.0.0.1:9000 minio miniokey`

# Minio startup
`minio server ANY_PATH_OF_YOUR_CHOICE`

## nosudo-clean
Getting it ready:

Compiling it yourself (recommended): `gcc -o nosudo-clean nosudo-clean.c`

Set own to root: `sudo chown root:root nosudo-clean`

Change permissions to run as root: `sudo chmod u=rws,g=rx,o=rx nosudo-clean`

**Never set o=rwx with u=s - it is a security violation!**

Running a non-sudo clean-up: `./cleanup.sh nosudo` which is equivalent to `./nosudo-clean`

This is program (not a bash script) is here to allow safely perform cleaning of docker temporary files stored in `robo/` folder. It is not possible without `sudo` permission, so an SUID privileged program is required to achieve this.

*Did you know?* Cleanup actually is optional and useful only if your workstation has little hard drive space (like mine). If you decide no to use it you will keep ALL checkpoints in `robo/container/tmpxxxxx/model/` directory, so you can fall back to any point you want.

## CMD

`sage.sh` and `robo.sh` start Anaconda environment automatically which is nice and convenient.

**I highly recommend revising these scripts before running them.** `queuerun.sh` actually provides `simulate` option to verify expected output *but it does not verify subscripts it is using!!!* (pretty much all CMD scripts)

Expected folder hierarchy:

```
deepracer/
---CMD/
---robo/
------job/
------container/
---all other crr0004 files
models/
---Model-1 (example)
---Model-2 (example)
myreward.py
mybetterreward.py
```

`s3server.sh` can be run with modified path.

I am using also a custom folder hierarchy on Minio server, so here it is
(if you do not like it you have to modify scripts yourself):

```
rewards/
---myreward.py
---mybetterreward.py
pretrained/
---model/
------chkpt
params/
---model_metadata.json
```

### Script compatibility
Some scripts work with all deepracer repos based on crr0004 work. These are:
- tracks.sh
- edit.sh
- newreward.sh
- newtrack.sh
- preview.sh

These may work if slight changes are applied:
- cleanup.sh - requires setup for usage of `robo/job/` and `robo/container/` dirs
- nosudo-clean - same as cleanup.sh
- hyper.sh - requires modified `rl_coach/rl_deepracer_coach_robomaker.py` to handle hyperparams loading from `hyper.env`
- s3server.sh - optional, starts server from binary file (alternative installation method), requires USERNAME update inside to work properly

Scripts that work currently only with Anaconda installed deepracer but can be modified to work with pure crr0004 repo as well:
- robo.sh
- sage.sh
- kill.sh

Automatic scripts require all of the above scripts to work except:
- s3server.sh (which should be started manually)
- user interface scripts: edit.sh, preview.sh, hyper.sh

Automatic scripts that require special configuration:
- autorun.sh - needs to run clean-up (can be commented if you do not want to clean), uses `mc` to remove previous run sagemaker bucket, starts sage.sh and robo.sh
- autostop.sh - will use `docker stop` to kill **ALL docker containers**, waits 10 seconds and removes ALL docker containers that did not remove automatically, generally if you run minio on docker you have to upgrade this script that it does remove only Sage and Robo containers
- autoupdate.sh - will send a model from models/ directory using `mc` (minio client) which installation has been already explained
- queuerun.sh - will work as soon as other auto scripts work

*I will accept pull requests that extend support for other repos but only if changes are made on a separate branch (e.g. ARCC-dr-dummies branch)*

### Automatic scripts
These scripts allow to clean run training, stop and save training, update training model to local S3 bucket.

Example usage:

```
cd path/deepracer/CMD
./autoupdate.sh ExistingModelName
./autorun.sh
./autostop.sh NewModelName
```

### Queue script
This script is stored in folder `CMD/queue` and allows to run much more advanced training sequences automatically.

```
CMD/
---queue/
------queue.conf (auto-generated)
------queuerun.sh
------yourmetadata.json
------higherspeed.json
```

`queuerun.sh` will provide you with help if started without any arguments (and many other scripts provide help if arguments were necessary).

`queue.conf` contains details about training sequence. Script will read only those entries that start with a number.

**ID has to be unique!**

I recommend running `simulate` option to detect `queue.conf` errors.

