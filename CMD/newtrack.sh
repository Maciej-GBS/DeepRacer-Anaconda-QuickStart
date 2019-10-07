cd `readlink -f $0 | xargs dirname`
cd ..
if [ $# -gt 0 ]
then
	sed -i "s/WORLD_NAME=\(.*\)/WORLD_NAME=$1/" rl_coach/env.sh && echo '--- Updated env.sh'
	head rl_coach/env.sh
	sleep 1
	sed -i "s/WORLD_NAME=\(.*\)/WORLD_NAME=$1/" robomaker.env && echo '--- Updated robomaker.env'
	head robomaker.env
else
	echo "Usage: $0 [track name]"
	echo "Available tracks:"
	CMD/tracks.sh
fi
