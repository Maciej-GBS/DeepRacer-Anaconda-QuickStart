PATH='/home/gbs/anaconda3/bin:'$PATH
source activate awsdr

cd `readlink -f $0 | xargs dirname`
cd ../rl_coach
source env.sh
python -s rl_deepracer_coach_robomaker_nvidia.py
