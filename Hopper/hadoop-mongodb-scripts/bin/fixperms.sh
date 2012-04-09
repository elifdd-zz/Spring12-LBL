#!/bin/sh

IN=tmp.$$


if [ "$USER" != "hadoop" ] ; then
  if [ $# -ne 1 ] ; then
    echo "Usage: fixperms.sh <directory>"
    exit
  fi
  OUTPUT=myOutputDir.$$
  echo $1 > $IN
  hadoop fs -put $IN $IN
  rm $IN

  hadoop jar $HADOOP_HOME/contrib/streaming/hadoop-0.20.2+228-streaming.jar \
    -D mapred.task.timeout=0 \
    -D mapred.map.tasks=1  \
    -numReduceTasks 0 \
   -input $IN \
   -output $OUTPUT \
   -mapper $HADOOP_HOME/bin/fixperms.sh \
   -reducer org.apache.hadoop.mapred.lib.IdentityReducer 
   
  hadoop fs -rmr $OUTPUT
  hadoop fs -rm $IN
else
  cat > /tmp/$IN
  FILE=$(cat /tmp/$IN)
  echo $FILE
  rm /tmp/$IN
  chmod -R 777 $FILE
fi
