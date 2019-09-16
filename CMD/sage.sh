cd `readlink -f $0 | xargs dirname`
cd ../rl_coach
source env.sh
python -s rl_deepracer_coach_robomaker.py
