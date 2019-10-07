cmdpath=`readlink -f $0 | xargs dirname`/..
# enter CMD/
cd $cmdpath
if [ $# -lt 1 ]; then
	echo "Usage: $0 <subcommand>"
	echo 'setup [number] - copy necessary files for n stages'
	echo 'start - start training for n steps each of a provided duration'
	echo 'clean - remove all stage files'
	echo 'simulate - print configuration do not start training'
	exit
fi

if [ "$1" = "setup" ] && [ $# -gt 1 ]; then
	echo 'Model base name: '
	read modelname
	echo 'Reward base name: '
	read rewardname
	echo "id;stage;reward;meta;model;track;minutes" > queue/queue.conf
	# enter deepracer/
	cd ..
	echo Backing up $rewardname
	cp ../$rewardname ../$rewardname.bak
	echo Backing up hyper.env
	cp rl_coach/hyper.env rl_coach/hyper.env.bak
	for i in `seq 1 $2`; do
		echo Generating files for $i stage...
		cp ../$rewardname $cmdpath/queue/$i-$rewardname
		cp rl_coach/hyper.env $cmdpath/queue/$i-hyper.env
		echo "$i;$i;$rewardname;default;$modelname;Mexico_track;60" >> $cmdpath/queue/queue.conf
	done
	echo '###'
	echo stage - settings id to use
	echo 'id - model version to save as (previous is loaded)'
	echo 'meta - model_metadata.json to use (keep "default" to use json found in model folder)'
	echo ' '
	echo IMPORTANT
	echo Provide $modelname-0 or any other id that training will start from!

elif [ "$1" = "start" ]; then
	for i in `cat queue/queue.conf | grep -E ^[0-9]*\; | cut -d ';' -f 1`; do
		# Load conf BLOCK
		# enter deepracer/
		cd $cmdpath/..
		stageid=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 2`
		rewardname=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 3`
		metaname=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 4`
		modelname=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 5`
		trackname=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 6`
		trainsec=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 7`
		echo "QUEUE: Training time in minutes: $trainsec"
		trainsec=`expr $trainsec \* 60`
		echo "QUEUE: Training time in seconds: $trainsec"
		echo QUEUE: Stage $stageid step $i: $rewardname $modelname $trackname
		echo QUEUE: Updating reward $rewardname...
		cp CMD/queue/$stageid-$rewardname ../$rewardname
		echo QUEUE: Updating hyperparams...
		cp CMD/queue/$stageid-hyper.env rl_coach/hyper.env
		# END BLOCK
		$cmdpath/newtrack.sh $trackname
		$cmdpath/newreward.sh $rewardname
		echo QUEUE: Updated track to $trackname
		if [ "$metaname" = "default" ]; then
			echo QUEUE: Using default model_metadata.json
			$cmdpath/autoupdate.sh $modelname-`expr $i - 1`
		else
			echo QUEUE: Overriding model_metadata.json
			$cmdpath/autoupdate.sh $modelname-`expr $i - 1` `readlink -f CMD/queue/$metaname`
		fi
		$cmdpath/autorun.sh
		echo QUEUE: Stopping at `date -d "now + $trainsec seconds"`
		sleep $trainsec
		$cmdpath/autostop.sh $modelname-$i
	done
	echo Done

elif [ "$1" = "clean" ]; then
	cd queue && rm [0-9]*-*
	echo Cleaned stage files

elif [ "$1" = "simulate" ]; then
	timesum=0
	for i in `cat queue/queue.conf | grep -E ^[0-9]*\; | cut -d ';' -f 1`; do
		# enter deepracer/
		cd $cmdpath/..
		stageid=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 2`
		rewardname=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 3`
		metaname=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 4`
		modelname=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 5`
		trackname=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 6`
		trainsec=`cat CMD/queue/queue.conf | grep -E ^$i\; | cut -d ';' -f 7`
		echo "QUEUE: Training time in minutes: $trainsec"
		trainsec=`expr $trainsec \* 60`
		timesum=`expr $trainsec + $timesum`
		echo "QUEUE: Training time in seconds: $trainsec"
		echo QUEUE: Stage $stageid step $i: $rewardname $modelname $trackname
		echo QUEUE: Updating reward $rewardname...
		echo QUEUE: Updating hyperparams...
		# END BLOCK
		echo QUEUE: Updated track to $trackname
		if [ "$metaname" = "default" ]; then
			echo QUEUE: Using default model_metadata.json
		else
			echo QUEUE: Overriding model_metadata.json
		fi
		echo QUEUE: Stopping at `date -d "now + $timesum seconds"`
		echo Would perform training - use start instead of simulate
	done
fi
