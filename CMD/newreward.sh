cd `readlink -f $0 | xargs dirname`
cd ..
if [ $# -gt 0 ]
then
	sed -i "s/REWARD_FILE_S3_KEY=rewards\/\(.*\)/REWARD_FILE_S3_KEY=rewards\/$1/" robomaker.env && echo '--- Updated robomaker.env'
	tail robomaker.env
else
	echo "Usage: $0 [reward name]"
	echo "Available rewards:"
	ls ../*.py
fi
