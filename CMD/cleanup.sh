cd `readlink -f $0 | xargs dirname`
cd ..
sudo rm -R simjob/* && echo Cleaned robo logs
sudo rm -R robo/container/* && echo Cleaned sagemaker temp
