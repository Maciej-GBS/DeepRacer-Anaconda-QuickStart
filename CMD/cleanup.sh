cd `readlink -f $0 | xargs dirname`
cd ..
sudo rm -R simjob/*
sudo rm -R robo/container/*
