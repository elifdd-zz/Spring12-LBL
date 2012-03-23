#!/bin/bash 

#PBS -l mppwidth=168
#PBS -q debug
#PBS -V
#PBS -j oe
#PBS -l walltime=00:05:30
#PBS -N 6mil-5n18m-2nd
#PBS -A m1104 
#PBS -S /bin/bash

#ARGUMENTS:
export DBPATH="test"
export numNodes="7"
export mapsPerNode="18"

echo "=== db_path : "$DBPATH
echo "=== number of nodes: "$numNodes
echo "=== maps per node : "$mapsPerNode

export MONGODB_HOST=`head -n 1 $PBS_NODEFILE`
echo "=======  Mongo server	:	"$MONGODB_HOST

echo "Starting MongoDB Server"
/global/homes/e/edede/Hopper/hadoop-moduled/./mongo-server.start $DBPATH
echo "--------------------------------------------"
sleep 10

echo "Putting data to mongo"
/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/putdata.js
#/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/putdata.js
#/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/putdata.js
echo "--------------------------------------------"
sleep 10


echo "Checking input data of mongo"
/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/datacheck.js
echo "--------------------------------------------"
sleep 10

echo "Loading modules..."
module use --append /usr/common/tig/Modules/modulefiles
module load hadoop

cd $PBS_O_WORKDIR

echo "Cleanup Previous Hadoop..."
./cleanup_hadoop_elif
sleep 5

echo "Starting Hadoop..."
rm exportpath
./start_hadoop_elif > exportpath
export hh=`cat exportpath`
#./start_hadoop_elif
#export hh=`/global/homes/e/edede/Hopper/hadoop-moduled/./start_hadoop_look`  
#export hh=`start_hadoop`
#`start_hadoop`
#`/global/homes/e/edede/Hopper/hadoop-moduled/./start_hadoop_elif`

echo "###################################################"
echo $hh

echo "###################################################"

sleep 2

echo "--------------------------------------------"
export path=`echo $hh | sed -e "s/.*IR=//;s/Starting.*//"`
echo " hadoop_conf_dir :"$path

##set up 1 map per node

#  echo "###################################################"
#  cd $path
#  ls
#  cat mapred-site.xml | sed "s/18/1/" > mapred-site.xml.maps
#  sleep 2
#  cat mapred-site.xml.maps | sed "s/8/1/" > mapred-site.xml
#  sleep 2 
echo "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
cd $path
cat mapred-site.xml
echo "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"

cd $PBS_O_WORKDIR  

##set up 1 map per node
export HADOOP_CONF_DIR=$path

sleep 2

echo "hadoop_conf_dir : "$HADOOP_CONF_DIR


echo "--------------------------------------------"
echo "Running Hadoop"
hadoop jar /global/homes/e/edede/Hopper/hadoop-moduled/mongo-hadoop/lib/WordCountExample.jar com.mongodb.hadoop.examples.wordcount.WordCount $MONGODB_HOST $DBPATH 
#>output.$PBS_JOBID
sleep 10
echo "--------------------------------------------"

echo "Checking output data of mongo"
/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/datacheck.js
echo "--------------------------------------------"

echo "--------------------------------------------"
echo "Cleaning Hadoop..."
./cleanup_hadoop_elif
#cleanup_hadoop



echo "========================== MONGO HADOOP JOB ENDS =============================="

