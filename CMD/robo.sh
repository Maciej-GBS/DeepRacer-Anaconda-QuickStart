# optional if anaconda is not in PATH by default
#PATH='/home/USERNAME/anaconda3/bin:'$PATH
source activate awsdr

cd `readlink -f $0 | xargs dirname`
source ../rl_coach/env.sh
cd ..

# No access to logs (only via docker robo logs)
#docker run --rm --name dr --env-file ./robomaker.env --network sagemaker-local -p 8080:5900 -it crr0004/deepracer_robomaker:console

# With log access (keep container up)
docker run --rm --name dr --env-file ./robomaker.env --network sagemaker-local -p 8080:5900 -v $(pwd)/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src:/app/robomaker-deepracer/simulation_ws/src -v $(pwd)/robo/job:/root/.ros/ -it crr0004/deepracer_robomaker:console "./run.sh build distributed_training.launch"

