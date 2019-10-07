CMDROOT=`readlink -f $0 | xargs dirname`
cd $CMDROOT

if [ $# -gt 0 ]
then
	echo Stop sequence initialized...
else
	echo "Usage: $0 [new model name] [OPTIONAL-save prelast]"
	echo Existing models:
	ls $CMDROOT/../../models
	exit
fi

# Stop training
$CMDROOT/kill.sh

# Backup all files
echo Backup $1 initialized...
cd $CMDROOT/../..
mkdir models/$1
cp deepracer/robo/job/log/*.log models/$1/
cp ~/s3storage/bucket/rl-deepracer-sagemaker/model/checkpoint models/$1/
cp ~/s3storage/bucket/rl-deepracer-sagemaker/model/model_metadata.json models/$1/

if [ $# -gt 1 ]; then
	lines=`wc -l models/$1/checkpoint | cut -d ' ' -f 1`
	lines=`expr $lines - 1`
	chkpt=`sed -n "${lines}p" models/$1/checkpoint | awk '{print $2}'`
	sed -i "s/path: \(.*\)/path: $chkpt/" models/$1/checkpoint
fi

chkpt=`head -n 1 models/$1/checkpoint | awk '{print $2}' | sed 's/"//g'`
echo Backing up $chkpt...
cp ~/s3storage/bucket/rl-deepracer-sagemaker/model/$chkpt* models/$1/

