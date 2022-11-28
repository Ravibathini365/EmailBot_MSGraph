#! /bin/bash

cwd=/home/rab/Test/botcmds

cd $cwd

statusjob()
{
if grep -w $2 $cwd/.servicename > /dev/null 2>&1
then 
  	service=`grep -w $2 $cwd/.servicename | cut -d'|' -f2` 
	sshpass -p `echo VGUkdEEqdDAK|base64 -d` ssh -q mgtansible@$1 "sudo systemctl status $service" > statusjob.tmp 2>&1
	if grep 'could not be found' $cwd/statusjob.tmp
	then 
     		echo "There is no such service hosted in $1" > statusjob.tmp
	else
		true
	fi
else
 	echo "I'm not sure how to help with $2, please reach out to Infra team for more details on this !! Thanks for interacting with me." > statusjob.tmp
fi
}

stopjob()
{
if grep -w $2 $cwd/.servicename > /dev/null 2>&1
then
        service=`grep -w $2 $cwd/.servicename | cut -d'|' -f2`
        sshpass -p `echo VGUkdEEqdDAK|base64 -d` ssh -q mgtansible@$1 "sudo systemctl stop $service" > statusjob.tmp 2>&1
        if grep 'could not be found' $cwd/statusjob.tmp
        then
                echo "There is no such service hosted in $1" > statusjob.tmp
        else
                true
        fi
else
        echo "I'm not sure how to help with $2, please reach out to Infra team for more details on this !! Thanks for interacting with me." > statusjob.tmp
fi
}

strtjob()
{
if grep -w $2 $cwd/.servicename > /dev/null 2>&1
then
        service=`grep -w $2 $cwd/.servicename | cut -d'|' -f2`
        sshpass -p `echo VGUkdEEqdDAK|base64 -d` ssh -q mgtansible@$1 "sudo systemctl start $service" > statusjob.tmp 2>&1
        if grep 'could not be found' $cwd/statusjob.tmp
        then
                echo "There is no such service hosted in $1" > statusjob.tmp
        else
                true
        fi
else
        echo "I'm not sure how to help with $2, please reach out to Infra team for more details on this !! Thanks for interacting with me." > statusjob.tmp
fi
}

restartjob()
{
if grep -w $2 $cwd/.servicename > /dev/null 2>&1
then
        service=`grep -w $2 $cwd/.servicename | cut -d'|' -f2`
        sshpass -p `echo VGUkdEEqdDAK|base64 -d` ssh -q mgtansible@$1 "sudo systemctl restart $service" > statusjob.tmp 2>&1
        if grep 'could not be found' $cwd/statusjob.tmp
        then
                echo "There is no such service hosted in $1" > statusjob.tmp
        else
                true
        fi
else
        echo "I'm not sure how to help with $2, please reach out to Infra team for more details on this !! Thanks for interacting with me." > statusjob.tmp
fi
}


if [ $3 == 'status' ]
then 
	statusjob $1 $2
elif [ $3 == 'start' ]
then 
	strtjob $1 $2
	statusjob $1 $2
elif [ $3 == 'stop' ]
then 
	stopjob $1 $2
	statusjob $1 $2
elif [ $3 == 'restart' ]
then
	restartjob $1 $2
	statusjob $1 $2
else
	echo "Usage of this command needs three arguments: servicestop.sh server service status/stop/start/restart" > statusjob.tmp
fi
