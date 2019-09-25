cd `readlink -f $0 | xargs dirname`
cd ..
if [ $# -gt 0 ]
then
	cat rl_coach/env.sh | sed -n "s/WORLD_NAME=\(.*\)/WORLD_NAME=$1/;p" | tee rl_coach/env.sh
	cat robomaker.env | sed -n "s/WORLD_NAME=\(.*\)/WORLD_NAME=$1/;p" | tee robomaker.env
else
	echo "Please provide track name:"
	CMD/tracks.sh
fi
