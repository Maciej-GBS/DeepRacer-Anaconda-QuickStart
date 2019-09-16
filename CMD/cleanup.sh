cd `readlink -f $0 | xargs dirname`
cd ..
sudo rm -R robo/job/*
sudo rm -R robo/container/*
