#!/bin/bash

Organization=$1

if [ -z $1 ];then
  echo "Usage 'travis-tools.sh ORGANIZATION_NAME'. You forgot to pass the name of your organization."
  exit 1
fi

travis whoami > /dev/null 2>&1
if [ $? -ne 0 ];then
  travis login --auto
fi

echo "`date +"%Y-%m-%d %H:%M"` - RESTARTING ALL BUILDS"

List_repos=`travis repos -a | grep $Organization`

for i in `echo "$List_repos"`; do
  History=`travis history -b master -r $i`
  Status=`echo $History | head -1 | cut -d' ' -f2`
  Build_ID=`echo $History | head -1 | cut -d' ' -f1 | cut -d# -f2`
  echo "Restarting repo $i last build #$Build_ID:"
  travis restart $BuildID -r $i
done

sleep 2h

echo "`date +"%Y-%m-%d %H:%M"` - RESTARTING FAILED BUILDS"

for i in `echo "$List_repos"`; do
  History=`travis history -b master -r $i`
  Status=`echo $History | head -1 | cut -d' ' -f2`
  Build_ID=`echo $History | head -1 | cut -d' ' -f1 | cut -d# -f2`
  if [ "$Status" = "errored:" ] || [ "$Status" = "failed:" ]; then
    echo "Failed repo: $i. Restarting last build #$Build_ID:"
    travis restart $BuildID -r $i
  fi
done
