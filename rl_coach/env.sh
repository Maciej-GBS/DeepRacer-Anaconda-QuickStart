cd /home/gbs/Documents/HashCode/DeepRacer/deepracer/rl_coach
export MINIO_ACCESS_KEY=minio
export MINIO_SECRET_KEY=miniokey
export AWS_ACCESS_KEY_ID=minio
export AWS_SECRET_ACCESS_KEY=miniokey
export TRAINING_TIME=1
export WORLD_NAME=Bowtie_track
export ROS_AWS_REGION=us-east-1
export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1
export MODEL_S3_PREFIX=rl-deepracer-sagemaker
export MODEL_S3_BUCKET=bucket
export LOCAL=True
export S3_ENDPOINT_URL=http://172.17.0.1:9000
export MARKOV_PRESET_FILE=deepracer.py
export LOCAL_ENV_VAR_JSON_PATH=$(readlink -f ./env_vars.json)
#export LOCAL_EXTRA_DOCKER_COMPOSE_PATH=$(readlink -f ./docker_compose_extra.json)
