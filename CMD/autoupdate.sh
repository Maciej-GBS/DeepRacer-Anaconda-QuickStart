s3location="s3local/bucket"
CMDROOT=`readlink -f $0 | xargs dirname`
cd $CMDROOT
cd ../../models

if [ $# -gt 0 ]
then
	echo Update sequence initialized...
else
	echo "Usage: $0 [model name] [OPTIONAL-metadata override]"
	echo Available models:
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
if [ $# -gt 1 ]; then
	echo Overriding json with $2
	mc cp $2 $s3location/params/model_metadata.json
else
	echo Using default model_metadata.json
	mc cp $1/model_metadata.json $s3location/params/
fi

echo Copying rewards...
cd ..
mc cp *.py $s3location/rewards/

