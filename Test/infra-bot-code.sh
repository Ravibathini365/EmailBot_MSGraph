#! /bin/bash

set -x
#bot working directory
bwd=/home/rab/Test

#bot commands directory
bcd=/home/rab/Test/botcmds
cd $bwd

email()
{
(
  echo To: $1
  echo From: rv.infrabot@victoria.com
  echo "Content-Type: text/html; "
  echo Subject: $sub-Response
  echo  'Hi from RV.Infrabot !! You can check my Menu for help : Usage: in Subject - Infrabot Menu'
) | /usr/sbin/sendmail -t
}

emailres()
{
(
  echo To: $1
  echo From: rv.infrabot@victoria.com
  echo "Content-Type: text/html; "
  echo Subject: $sub-Response
  cat $file
) | /usr/sbin/sendmail -t
}

html()
{
awk 'BEGIN{
FS="|"
print "<html><body>"
print "<table border="1"><TH>Command</TH><TH>Command_Description</TH>"
}
{
printf "<TR>"
for (i=1;i<=NF;i++)
   printf "<TD>%s</TD>", $i
   print "</TR>"
}
END {
     print "</table></body></html>"
    }
' $1 > ${1}.html
}

menu()
{
    html $bwd/infrabotmenu
    file=$bwd/infrabotmenu.html
}

if [ -s $bwd/email.log ]
then 

cat $bwd/email.log|jq -c '.|.value[]|.id' > id.tmp
cat $bwd/email.log|jq -c '.|.value[]|.subject' > subj.tmp
cat $bwd/email.log|jq -c '.|.value[]|.sender' > sender.tmp

paste id.tmp subj.tmp sender.tmp | tr '\t' '|' > email.tmp

cat $bwd/email.tmp | while read line
do
         id=`echo $line|cut -d '|' -f1| sed 's/"//g'`
         sub=`echo $line|cut -d '|' -f2|sed 's/"//g'`
 	 sender=`echo $line|cut -d '|' -f3| cut -d ':' -f4 | sed 's/"//g'| sed 's/}}//'`
 	 if echo $sub | grep -i infrabot
 	 then

     	 	botcmd=`echo $line|cut -d '|' -f2|sed 's/"//g'| cut -d ' ' -f2`.sh
     		if ls -l  $bcd/$botcmd > /dev/null 2>&1
     		then 
                        if ls -l  $bcd/$botcmd | grep -i getjenkinsjob > /dev/null 2>&1
                        then 
          			sh $bcd/$botcmd
				file=$bcd/jenkinjob.html
          			emailres $sender $sub $file
                                rm -f $bcd/jenkinjob $bcd/jenkinjob.html
			elif ls -l  $bcd/$botcmd | grep -i servicestop > /dev/null 2>&1
                        then
     				server=`echo $line|cut -d '|' -f2|sed 's/"//g'|cut -d ' ' -f2`
				sh $bcd/$botcmd $server
			fi 
              
		elif echo $botcmd | grep -i menu
                then
                        menu
                        emailres $sender $sub $file
 		else
            		file=$bwd/botreply
			emailres $sender $sub $file
     		fi
 	else
     		email $sender $sub
 	fi
done

rm -f $bwd/email.log

else
      exit 1
fi
