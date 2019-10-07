# optional if anaconda is not in PATH by default
#PATH='/home/USERNAME/anaconda3/bin:'$PATH
source activate awsdr

cd `readlink -f $0 | xargs dirname`
cd ../rl_coach
source env.sh

if [ "$1" = "create" ]; then
	echo '+ NOT USING PRETRAINED'
	python -s rl_deepracer_coach_robomaker_create.py
else
	python -s rl_deepracer_coach_robomaker_nvidia.py
fi
