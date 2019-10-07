cd `readlink -f $0 | xargs dirname`
if [ "$1" = "nosudo" ]; then
	./nosudo-clean
else
	cd ..
	sudo rm -R robo/job/* && echo Cleaned robo logs
	sudo rm -R robo/container/* && echo Cleaned sagemaker temp
fi
