#!/bin/bash 

#PBS -l mppwidth=120
#PBS -q debug
#PBS -V
#PBS -j oe
#PBS -l walltime=00:04:30
#PBS -N 19MB
#PBS -A m1104 
#PBS -S /bin/bash

#ARGUMENTS:

export outputdir="/scratch/scratchdirs/edede/MyHadoop/hadoop-data/output/ZachsBenchMarkData/censusdata/labellingWgR"
export inputdir="/scratch/scratchdirs/edede/MyHadoop/hadoop-data/input/ZachsBenchMarkData/censusdata/censusdata.sample"
export TESTNAME="MongoDB labellingWgR on census data"
export DBPATH="test"
export numNodes="5"
export mapsPerNode="18"
export totalmaps="90"  ##do the multiplication

echo "=== db_path : "$DBPATH
echo "=== number of nodes: "$numNodes
echo "=== maps per node : "$mapsPerNode
echo "=== test_name : "$TESTNAME
echo "=== input_dir : "$inputdir
echo "=== output_dir : "$outputdir
echo "=== total_num_maps" : $totalmaps
echo "=== input_size" : `ls -al $inputdir`


export MONGODB_HOST=`head -n 1 $PBS_NODEFILE`
echo "===  Mongo server	:	"$MONGODB_HOST

echo "Starting MongoDB Server"
/global/homes/e/edede/Hopper/hadoop-moduled/./mongo-server.start.for.client $DBPATH
echo "--------------------------------------------"
sleep 2

echo "Loading modules..."
module use --append /usr/common/tig/Modules/modulefiles
module load hadoop

#echo "--------------------------------------------"
#echo "Putting data to mongo"
#cd /global/homes/e/edede/Spring12-LBL/Hopper/experiments/ZachsBenchMarks/censusprocessing/genderFilterRgW/mongo-vs
#java -classpath ":mongo-2.7.2.jar" MongoClient $MONGODB_HOST $inputdir
#cd ..
#sleep 2

#echo "--------------------------------------------"
#echo "Checking input data of mongo"
#/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/datacheck.js

echo "--------------------------------------------"
echo "Clean up old output data of mongo"
/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/cleanoutput.js
sleep 2

echo "--------------------------------------------"
echo "Cleanup Previous Hadoop..."
cleanup_hadoop
sleep 3

echo "--------------------------------------------"
echo "Starting Hadoop..."
rm exportpath
start_hadoop > exportpath
export hh=`cat exportpath`

sleep 2

echo "--------------------------------------------"
export path=`echo $hh | sed -e "s/.*IR=//;s/Starting.*//"`
echo "hadoop_conf_dir :"$path
export HADOOP_CONF_DIR=$path
sleep 2

echo "hadoop_conf_dir : "$HADOOP_CONF_DIR


cd $PBS_O_WORKDIR
echo "--------------------------------------------"
echo "Running Hadoop"
#hadoop jar labellingWgR.jar labellingWgR $MONGODB_HOST $DBPATH 
#>output.$PBS_JOBID
hadoop jar genderFilterRgW.jar genderFilterRgW $MONGODB_HOST $DBPATH
sleep 10

echo "--------------------------------------------"
echo "Checking output data of mongo"
/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/datacheck.js

echo "--------------------------------------------"
echo "Cleaning Hadoop..."
#./cleanup_hadoop_elif
cleanup_hadoop



echo "========================== MONGO HADOOP JOB ENDS =============================="

