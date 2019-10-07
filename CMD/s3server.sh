cd `readlink -f $0 | xargs dirname`
cd ..
source rl_coach/env.sh
minio server /home/USERNAME/s3storage
