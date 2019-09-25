CMDROOT=`readlink -f $0 | xargs dirname`
cd $CMDROOT

if [ $# -gt 0 ]
then
	echo Stop sequence initialized...
else
	echo Provide model name as argument
	ls $CMDROOT/../../models
	exit
fi

# Stop training
$CMDROOT/kill.sh

# Backup all files
echo Backup $1 initialized...
cd $CMDROOT/../..
mkdir models/$1
cp deepracer/simjob/log/*.log models/$1/
cp ~/s3storage/bucket/rl-deepracer-sagemaker/model/checkpoint models/$1/
cp ~/s3storage/bucket/rl-deepracer-sagemaker/model/model_metadata.json models/$1/
chkpt=`head -n 1 models/$1/checkpoint | awk '{print $2}' | sed 's/"//g'`
echo Backing up $chkpt...
cp ~/s3storage/bucket/rl-deepracer-sagemaker/model/$chkpt* models/$1/

