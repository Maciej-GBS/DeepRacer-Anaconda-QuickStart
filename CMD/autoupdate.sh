s3location="s3local/bucket"
CMDROOT=`readlink -f $0 | xargs dirname`
cd $CMDROOT
cd ../../models

if [ $# -gt 0 ]
then
	echo Update sequence initialized...
else
	echo Provide model name as argument
	ls $CMDROOT/../../models
	exit
fi

echo Removing old files...
mc rm -r --force $s3location/pretrained/model/
mc rm -r --force $s3location/rewards/
mc mb $s3location/pretrained/model/
mc mb $s3location/rewards/

echo Copying new $1 files...
mc cp $1/checkpoint $s3location/pretrained/model/
mc cp $1/*ckpt* $s3location/pretrained/model/
mc cp $1/model_metadata.json $s3location/params/

echo Copying rewards...
cd ..
mc cp racingliner.py $s3location/rewards/
mc cp skillmaster.py $s3location/rewards/
mc cp vettel.py $s3location/rewards/

