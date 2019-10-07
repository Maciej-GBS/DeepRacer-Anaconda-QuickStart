docker stop `docker ps -a | grep -iv container | cut -d ' ' -f 1`
sleep 10
docker rm `docker ps -a | grep -iv container | cut -d ' ' -f 1`
docker ps -a

