#! /bin/bash

cwd=/home/rab/Test/botcmds
curl -X GET -s -u RAB:11a630d3ee5f5da16a139befde1f529c6e https://etojenkins.vsazure.com/api/json | jq '.jobs[].name' | sed 's/"//g' > $cwd/jenkinjob

html()
{
awk 'BEGIN{
FS="|"
print "<html><body>"
print "<table border="1"><TH>Job_Name</TH>"
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

html $cwd/jenkinjob
