#! /bin/bash

set -x
cwd=/Users/RaB/Runbooks/Infra_Email_bot

cd $cwd

email()
{
(
  echo To: $1
  echo From: rv.infrabot@lb.com
  echo "Content-Type: text/html; "
  echo Subject: $2
  echo -e 'Hi from RV.Infrabot !!'
) | /usr/sbin/sendmail -t
}

html()
{
awk 'BEGIN{
FS="|"
print "<html><body>"
print "<table border="1"><TH>Hostname</TH><TH>Service_Description</TH><TH>Author_name</TH><TH>Comment</TH><TH>Start_time</TH><TH>End_time</TH>"
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

cat $cwd/email.log|/usr/local/bin/jq -c '.|.value[]|.id' > id.tmp
cat $cwd/email.log|/usr/local/bin/jq -c '.|.value[]|.subject' > subj.tmp
cat $cwd/email.log|/usr/local/bin/jq -c '.|.value[]|.sender' > sender.tmp

paste id.tmp subj.tmp sender.tmp | tr '\t' '|' > email.tmp

cat $cwd/email.tmp | while read line
do 
 sub=`echo $line|cut -d '|' -f1`
 sender=`echo $line|cut -d '|' -f2| cut -d ':' -f4 | sed 's/"//g'| sed 's/}}//'`
 if echo $sub | grep -i infrabot
 then 
     email $sender $sub
 fi
done

