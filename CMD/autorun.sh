CMDROOT=`readlink -f $0 | xargs dirname`
cd $CMDROOT

# Prepare for clean run
$CMDROOT/cleanup.sh nosudo
mc rm -r --force s3local/bucket/rl-deepracer-sagemaker/
mc rm --force s3local/bucket/metric.json

# Start sage wait start robo in separate terminals
echo Starting SageMaker...
x-terminal-emulator -e "bash -c $CMDROOT/sage.sh"
echo Waiting for SageMaker to start...
sleep 60
echo Starting RoboMaker...
x-terminal-emulator -e "bash -c $CMDROOT/robo.sh"

